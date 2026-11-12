package com.library.util;

import com.library.model.Book;
import com.library.model.CartItem;
import com.library.model.User;

import jakarta.servlet.ServletContext;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Utility class that integrates DC Library with the Google Gemini REST API
 * for Natural Language Smart Book Search and the AI Library Chatbot Assistant.
 */
public class AIService {

    private static final String DEFAULT_MODEL = "gemini-3.8-flash";
    private static final String FALLBACK_MODEL = "gemini-2.5-flash";
    private static final String GEMINI_ENDPOINT_TEMPLATE =
            "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent";

    private static final HttpClient HTTP_CLIENT = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .build();

    private static final Set<String> STOP_WORDS = new HashSet<>(Arrays.asList(
            "a", "an", "the", "i", "me", "my", "want", "need", "looking", "for",
            "book", "books", "on", "about", "with", "in", "of", "to", "and", "or",
            "please", "show", "find", "give", "get", "some", "any", "good", "best",
            "beginner", "friendly", "beginner-friendly", "similar", "like", "do", "you", "have"
    ));

    public static class SearchResult {
        private final List<Integer> bookIds;
        private final boolean aiPowered;
        private final String statusNote;

        public SearchResult(List<Integer> bookIds, boolean aiPowered, String statusNote) {
            this.bookIds = bookIds;
            this.aiPowered = aiPowered;
            this.statusNote = statusNote;
        }

        public List<Integer> getBookIds() {
            return bookIds;
        }

        public boolean isAiPowered() {
            return aiPowered;
        }

        public String getStatusNote() {
            return statusNote;
        }
    }

    public static class ChatResult {
        private final String reply;
        private final boolean aiPowered;

        public ChatResult(String reply, boolean aiPowered) {
            this.reply = reply;
            this.aiPowered = aiPowered;
        }

        public String getReply() {
            return reply;
        }

        public boolean isAiPowered() {
            return aiPowered;
        }
    }

    /**
     * Uses Gemini REST API to match a natural language query against the library catalog
     * and return matching Book IDs in relevance order.
     */
    public static SearchResult smartSearchBookIds(String userQuery, List<Book> catalog, ServletContext context) {
        if (catalog == null || catalog.isEmpty()) {
            return new SearchResult(new ArrayList<>(), false, "The library catalog is currently empty.");
        }

        String trimmedQuery = userQuery == null ? "" : userQuery.trim();
        if (trimmedQuery.isEmpty()) {
            List<Integer> allIds = new ArrayList<>();
            for (Book b : catalog) {
                allIds.add(b.getId());
            }
            return new SearchResult(allIds, false, "Showing all books.");
        }

        String apiKey = resolveApiKey(context);
        if (apiKey != null) {
            StringBuilder catalogText = new StringBuilder();
            Set<Integer> validIds = new HashSet<>();
            for (Book b : catalog) {
                validIds.add(b.getId());
                catalogText.append(String.format(
                        "ID: %d | Title: %s | Author: %s | Price: Rs. %.2f | Stock: %d (%s)%n",
                        b.getId(),
                        safeStr(b.getTitle()),
                        safeStr(b.getAuthor(), "Unknown"),
                        b.getPrice(),
                        b.getQuantity(),
                        b.getQuantity() > 0 ? "In Stock" : "Out of Stock"
                ));
            }

            String prompt = "You are a smart book search engine for DC Library.\n"
                    + "Analyze the user's natural language search query and match it against the available book catalog below.\n"
                    + "Consider topic relevance, related concepts, author names, price constraints, and stock availability if mentioned.\n\n"
                    + "Book Catalog:\n"
                    + catalogText
                    + "\nUser Query: \"" + trimmedQuery + "\"\n\n"
                    + "Instructions:\n"
                    + "- Return ONLY a comma-separated list of matching Book IDs ordered from most relevant to least relevant (example: 2, 1).\n"
                    + "- If NO books in the catalog match the user's query, return ONLY the word NONE.\n"
                    + "- Do NOT include any explanation, markdown formatting, or extra words.";

            try {
                String aiText = callGeminiApi(prompt, 0.1, apiKey, context);
                if (aiText != null) {
                    List<Integer> matchedIds = parseBookIds(aiText, validIds);
                    return new SearchResult(
                            matchedIds,
                            true,
                            "Semantic search powered by Gemini AI"
                    );
                }
            } catch (Exception e) {
                System.err.println("[AIService] Smart search Gemini API error: " + e.getMessage());
            }
        }

        List<Integer> fallbackIds = fallbackKeywordSearch(trimmedQuery, catalog);
        String note = (apiKey == null)
                ? "Smart local matching active (set GEMINI_API_KEY to enable Gemini AI)"
                : "Smart local matching active (Gemini API temporarily unavailable)";
        return new SearchResult(fallbackIds, false, note);
    }

    /**
     * Powers the AI Library Chatbot Assistant using real-time BookDAO catalog
     * and CartDAO cart data injected into the Gemini prompt context.
     */
    public static ChatResult askLibraryAssistant(
            String userMessage,
            List<Book> catalog,
            List<CartItem> cartItems,
            User user,
            ServletContext context) {

        String cleanMessage = userMessage == null ? "" : userMessage.trim();
        if (cleanMessage.isEmpty()) {
            return new ChatResult("Please type a question about our books, stock, or your cart.", false);
        }

        String apiKey = resolveApiKey(context);
        if (apiKey != null) {
            String contextBlock = buildAssistantContext(catalog, cartItems, user);
            String prompt = "You are the friendly, concise AI Library Assistant for DC Library.\n"
                    + "Answer the user's question strictly using the real-time library catalog and cart data provided below.\n"
                    + "Do NOT invent books, authors, prices, or stock counts that are not in the data.\n"
                    + "Format currency in Rs. (or ₹). Keep answers clear, helpful, and under 120 words unless listing multiple books.\n\n"
                    + contextBlock
                    + "\nUser Question: \"" + cleanMessage + "\"\n\n"
                    + "Assistant Answer:";

            try {
                String aiText = callGeminiApi(prompt, 0.4, apiKey, context);
                if (aiText != null && !aiText.trim().isEmpty()) {
                    return new ChatResult(aiText.trim(), true);
                }
            } catch (Exception e) {
                System.err.println("[AIService] Chatbot Gemini API error: " + e.getMessage());
            }
        }

        String fallbackReply = fallbackAssistantReply(cleanMessage, catalog, cartItems, user, apiKey == null);
        return new ChatResult(fallbackReply, false);
    }

    private static String buildAssistantContext(List<Book> catalog, List<CartItem> cartItems, User user) {
        StringBuilder sb = new StringBuilder();
        sb.append("=== REAL-TIME LIBRARY CATALOG ===\n");
        if (catalog == null || catalog.isEmpty()) {
            sb.append("No books currently in catalog.\n");
        } else {
            for (Book b : catalog) {
                sb.append(String.format(
                        "- [ID %d] \"%s\" by %s | Price: ₹%.2f | Stock: %d (%s)\n",
                        b.getId(),
                        safeStr(b.getTitle()),
                        safeStr(b.getAuthor(), "Unknown"),
                        b.getPrice(),
                        b.getQuantity(),
                        b.getQuantity() > 0 ? "In Stock" : "Out of Stock"
                ));
            }
        }

        sb.append("\n=== USER & REAL-TIME CART DATA ===\n");
        if (user == null) {
            sb.append("User Status: Guest (not logged in). Cart data unavailable until user logs in.\n");
        } else {
            sb.append("Logged-in User: ").append(safeStr(user.getName(), "Member"))
              .append(" (Role: ").append(safeStr(user.getRole(), "user")).append(")\n");
            if (cartItems == null || cartItems.isEmpty()) {
                sb.append("Cart Status: Empty (0 items, Total: ₹0.00).\n");
            } else {
                double total = 0;
                int totalUnits = 0;
                sb.append("Cart Items:\n");
                for (CartItem item : cartItems) {
                    double price = item.getBook().getPrice();
                    int qty = item.getQuantity();
                    double sub = price * qty;
                    total += sub;
                    totalUnits += qty;
                    sb.append(String.format(
                            "- \"%s\" by %s | Qty: %d | Unit Price: ₹%.2f | Subtotal: ₹%.2f\n",
                            safeStr(item.getBook().getTitle()),
                            safeStr(item.getBook().getAuthor(), "Unknown"),
                            qty,
                            price,
                            sub
                    ));
                }
                sb.append(String.format("Total Cart Units: %d | Grand Total Price: ₹%.2f\n", totalUnits, total));
            }
        }
        return sb.toString();
    }

    private static String callGeminiApi(String prompt, double temperature, String apiKey, ServletContext context)
            throws Exception {
        String primaryModel = resolveModel(context);
        List<String> modelsToTry = new ArrayList<>();
        modelsToTry.add(primaryModel);
        if (!FALLBACK_MODEL.equals(primaryModel)) {
            modelsToTry.add(FALLBACK_MODEL);
        }

        String requestBody = "{"
                + "\"contents\":[{\"parts\":[{\"text\":\"" + escapeJson(prompt) + "\"}]}],"
                + "\"generationConfig\":{\"temperature\":" + temperature + "}"
                + "}";

        Exception lastException = null;
        for (String model : modelsToTry) {
            String url = String.format(GEMINI_ENDPOINT_TEMPLATE, model);
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .timeout(Duration.ofSeconds(20))
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .header("x-goog-api-key", apiKey)
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                    .build();

            HttpResponse<String> response = HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString());
            int status = response.statusCode();
            if (status >= 200 && status < 300) {
                String extracted = extractTextFromGeminiResponse(response.body());
                if (extracted != null) {
                    return extracted;
                }
                throw new IllegalStateException("Could not parse text from Gemini response.");
            }

            lastException = new IllegalStateException("Gemini API HTTP " + status + ": " + response.body());
            if (status != 404) {
                break;
            }
        }
        if (lastException != null) {
            throw lastException;
        }
        return null;
    }

    private static List<Integer> parseBookIds(String aiText, Set<Integer> validIds) {
        List<Integer> result = new ArrayList<>();
        if (aiText == null) {
            return result;
        }
        String trimmed = aiText.trim().toUpperCase(Locale.ROOT);
        if ("NONE".equals(trimmed)) {
            return result;
        }

        Set<Integer> unique = new LinkedHashSet<>();
        Matcher matcher = Pattern.compile("\\d+").matcher(aiText);
        while (matcher.find()) {
            try {
                int id = Integer.parseInt(matcher.group());
                if (validIds.contains(id)) {
                    unique.add(id);
                }
            } catch (NumberFormatException ignored) {
            }
        }
        result.addAll(unique);
        return result;
    }

    private static List<Integer> fallbackKeywordSearch(String query, List<Book> catalog) {
        String lower = query.toLowerCase(Locale.ROOT);
        boolean requireInStock = lower.contains("in stock") || lower.contains("available");
        Double maxPrice = extractMaxPrice(lower);

        List<String> tokens = new ArrayList<>();
        for (String raw : lower.split("[^a-z0-9]+")) {
            if (raw.length() >= 2 && !STOP_WORDS.contains(raw) && !raw.equals("stock") && !raw.equals("available")
                    && !raw.equals("under") && !raw.equals("below") && !raw.equals("less")) {
                tokens.add(raw);
                // Add lightweight domain aliases for better offline matching
                if (raw.equals("db") || raw.equals("database") || raw.equals("databases") || raw.equals("sql")) {
                    tokens.add("mysql");
                } else if (raw.equals("dsa") || raw.equals("algorithm") || raw.equals("algorithms")) {
                    tokens.add("structures");
                } else if (raw.equals("backend") || raw.equals("coding") || raw.equals("programming")) {
                    tokens.add("java");
                }
            }
        }

        List<Integer> matched = new ArrayList<>();
        for (Book b : catalog) {
            if (requireInStock && b.getQuantity() <= 0) {
                continue;
            }
            if (maxPrice != null && b.getPrice() > maxPrice) {
                continue;
            }
            if (tokens.isEmpty()) {
                matched.add(b.getId());
                continue;
            }
            String haystack = (safeStr(b.getTitle()) + " " + safeStr(b.getAuthor())).toLowerCase(Locale.ROOT);
            for (String token : tokens) {
                if (haystack.contains(token)) {
                    matched.add(b.getId());
                    break;
                }
            }
        }
        return matched;
    }

    private static Double extractMaxPrice(String lowerQuery) {
        Matcher m = Pattern.compile("(?:under|below|less than|<=?)\\s*(?:rs\\.?|₹)?\\s*(\\d+(?:\\.\\d+)?)").matcher(lowerQuery);
        if (m.find()) {
            try {
                return Double.parseDouble(m.group(1));
            } catch (NumberFormatException ignored) {
            }
        }
        return null;
    }

    private static String fallbackAssistantReply(
            String message,
            List<Book> catalog,
            List<CartItem> cartItems,
            User user,
            boolean missingKey) {

        String lower = message.toLowerCase(Locale.ROOT);
        StringBuilder reply = new StringBuilder();

        if (lower.contains("cart") || lower.contains("total price") || lower.contains("my order total")) {
            if (user == null) {
                reply.append("You're not logged in yet! Please login first so I can check the books and total price in your cart.");
            } else if (cartItems == null || cartItems.isEmpty()) {
                reply.append("Hi ").append(safeStr(user.getName(), "there"))
                     .append(", your cart is currently empty (Total: ₹0.00). Browse our catalog to add books!");
            } else {
                double total = 0;
                int units = 0;
                reply.append("Here is what's currently in your cart:\n");
                for (CartItem item : cartItems) {
                    double sub = item.getBook().getPrice() * item.getQuantity();
                    total += sub;
                    units += item.getQuantity();
                    reply.append(String.format("• %s (x%d) — ₹%.2f\n",
                            safeStr(item.getBook().getTitle()), item.getQuantity(), sub));
                }
                reply.append(String.format("Total (%d item unit%s): ₹%.2f",
                        units, units == 1 ? "" : "s", total));
            }
        } else if (lower.contains("stock") || lower.contains("available") || lower.contains("catalog") || lower.contains("what books")) {
            if (catalog == null || catalog.isEmpty()) {
                reply.append("There are currently no books in the library catalog.");
            } else {
                List<Book> inStock = new ArrayList<>();
                List<Book> outOfStock = new ArrayList<>();
                for (Book b : catalog) {
                    if (b.getQuantity() > 0) {
                        inStock.add(b);
                    } else {
                        outOfStock.add(b);
                    }
                }
                reply.append("Here is our live library stock:\n");
                for (Book b : inStock) {
                    reply.append(String.format("• %s by %s — ₹%.2f (%d in stock)\n",
                            safeStr(b.getTitle()), safeStr(b.getAuthor(), "Unknown"), b.getPrice(), b.getQuantity()));
                }
                if (!outOfStock.isEmpty()) {
                    reply.append("Currently out of stock: ");
                    for (int i = 0; i < outOfStock.size(); i++) {
                        if (i > 0) reply.append(", ");
                        reply.append(safeStr(outOfStock.get(i).getTitle()));
                    }
                    reply.append(".");
                }
            }
        } else {
            List<Book> matches = new ArrayList<>();
            if (catalog != null) {
                for (Book b : catalog) {
                    String title = safeStr(b.getTitle()).toLowerCase(Locale.ROOT);
                    String author = safeStr(b.getAuthor()).toLowerCase(Locale.ROOT);
                    for (String word : lower.split("[^a-z0-9]+")) {
                        if (word.length() >= 3 && !STOP_WORDS.contains(word)
                                && (title.contains(word) || author.contains(word))) {
                            matches.add(b);
                            break;
                        }
                    }
                }
            }
            if (!matches.isEmpty()) {
                reply.append("I found these matching books in DC Library:\n");
                for (Book b : matches) {
                    reply.append(String.format("• %s by %s — ₹%.2f (%s)\n",
                            safeStr(b.getTitle()),
                            safeStr(b.getAuthor(), "Unknown"),
                            b.getPrice(),
                            b.getQuantity() > 0 ? b.getQuantity() + " in stock" : "Out of stock"));
                }
            } else {
                int count = catalog == null ? 0 : catalog.size();
                reply.append("I checked our catalog (").append(count)
                     .append(" book(s)), and I couldn't find an exact match for that query. Try asking about available stock, a specific title/author, or your cart total!");
            }
        }

        if (missingKey) {
            reply.append("\n\n(Tip: Set GEMINI_API_KEY in your environment or web.xml to enable full Gemini AI answers.)");
        }
        return reply.toString().trim();
    }

    private static String resolveApiKey(ServletContext context) {
        String key = cleanConfigValue(System.getenv("GEMINI_API_KEY"));
        if (key != null) return key;

        key = cleanConfigValue(System.getProperty("gemini.api.key"));
        if (key != null) return key;

        if (context != null) {
            key = cleanConfigValue(context.getInitParameter("geminiApiKey"));
            if (key != null) return key;
        }
        return null;
    }

    private static String resolveModel(ServletContext context) {
        String model = cleanConfigValue(System.getenv("GEMINI_MODEL"));
        if (model != null) return model;

        model = cleanConfigValue(System.getProperty("gemini.model"));
        if (model != null) return model;

        if (context != null) {
            model = cleanConfigValue(context.getInitParameter("geminiModel"));
            if (model != null) return model;
        }
        return DEFAULT_MODEL;
    }

    private static String cleanConfigValue(String val) {
        if (val == null) return null;
        String trimmed = val.trim();
        if (trimmed.isEmpty() || "YOUR_GEMINI_API_KEY_HERE".equalsIgnoreCase(trimmed)) {
            return null;
        }
        return trimmed;
    }

    /**
     * Extracts the generated text from Gemini's JSON response without external JSON jars,
     * skipping any "thought": true parts if the model emits reasoning parts.
     */
    static String extractTextFromGeminiResponse(String json) {
        if (json == null || json.isEmpty()) {
            return null;
        }
        int candidatesIdx = json.indexOf("\"candidates\"");
        int searchStart = candidatesIdx >= 0 ? candidatesIdx : 0;
        int partsIdx = json.indexOf("\"parts\"", searchStart);
        int cursor = partsIdx >= 0 ? partsIdx : searchStart;

        String lastText = null;
        while (cursor < json.length()) {
            int textKeyIdx = json.indexOf("\"text\"", cursor);
            if (textKeyIdx < 0) {
                break;
            }
            int colonIdx = json.indexOf(':', textKeyIdx + 6);
            if (colonIdx < 0) {
                break;
            }
            int startQuote = -1;
            for (int i = colonIdx + 1; i < json.length(); i++) {
                char c = json.charAt(i);
                if (Character.isWhitespace(c)) {
                    continue;
                }
                if (c == '"') {
                    startQuote = i;
                }
                break;
            }
            if (startQuote < 0) {
                cursor = colonIdx + 1;
                continue;
            }

            StringBuilder out = new StringBuilder();
            int endQuote = -1;
            for (int i = startQuote + 1; i < json.length(); i++) {
                char c = json.charAt(i);
                if (c == '"') {
                    endQuote = i;
                    break;
                }
                if (c == '\\' && i + 1 < json.length()) {
                    char next = json.charAt(++i);
                    switch (next) {
                        case '"': out.append('"'); break;
                        case '\\': out.append('\\'); break;
                        case '/': out.append('/'); break;
                        case 'b': out.append('\b'); break;
                        case 'f': out.append('\f'); break;
                        case 'n': out.append('\n'); break;
                        case 'r': out.append('\r'); break;
                        case 't': out.append('\t'); break;
                        case 'u':
                            if (i + 4 < json.length()) {
                                String hex = json.substring(i + 1, i + 5);
                                try {
                                    out.append((char) Integer.parseInt(hex, 16));
                                    i += 4;
                                } catch (NumberFormatException e) {
                                    out.append("\\u").append(hex);
                                    i += 4;
                                }
                            }
                            break;
                        default:
                            out.append(next);
                            break;
                    }
                } else {
                    out.append(c);
                }
            }

            if (endQuote < 0) {
                break;
            }

            // Check if this part object is marked with "thought": true (either before or after "text")
            int prevBrace = json.lastIndexOf('{', textKeyIdx);
            int nextBrace = json.indexOf('}', endQuote + 1);
            boolean isThoughtPart = false;
            if (prevBrace >= 0) {
                String head = json.substring(prevBrace, textKeyIdx);
                if (head.contains("\"thought\"") && head.contains("true")) {
                    isThoughtPart = true;
                }
            }
            if (!isThoughtPart && nextBrace > endQuote) {
                String tail = json.substring(endQuote + 1, nextBrace);
                if (tail.contains("\"thought\"") && tail.contains("true")) {
                    isThoughtPart = true;
                }
            }

            if (!isThoughtPart) {
                return out.toString();
            }
            lastText = out.toString();
            cursor = endQuote + 1;
        }
        return lastText;
    }

    public static String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder(input.length() + 16);
        for (int i = 0; i < input.length(); i++) {
            char c = input.charAt(i);
            switch (c) {
                case '"': sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\b': sb.append("\\b"); break;
                case '\f': sb.append("\\f"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default:
                    if (c < 0x20) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
                    break;
            }
        }
        return sb.toString();
    }

    private static String safeStr(String s) {
        return safeStr(s, "");
    }

    private static String safeStr(String s, String fallback) {
        return (s == null || s.trim().isEmpty()) ? fallback : s.trim();
    }
}
