package util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

public class CookieUtil {
    private static final String AUTH_COOKIE_NAME = "auth_token";
    private static final String USER_ID_COOKIE_NAME = "user_id";
    private static final int COOKIE_MAX_AGE = 7 * 24 * 60 * 60; // 1 week
    private static final Map<String, Long> tokenStore = new HashMap<>();
    private static final Map<String, Integer> tokenUserMap = new HashMap<>();

    public static String generateToken(int userId) {
        try {
            SecureRandom random = new SecureRandom();
            byte[] tokenBytes = new byte[32];
            random.nextBytes(tokenBytes);
            String token = Base64.getEncoder().encodeToString(tokenBytes);

            long timestamp = System.currentTimeMillis();
            tokenStore.put(token, timestamp);
            tokenUserMap.put(token, userId);

            return token;
        } catch (Exception e) {
            return null;
        }
    }

    public static void setAuthCookie(HttpServletResponse response, String token, int userId) {
        Cookie authCookie = new Cookie(AUTH_COOKIE_NAME, token);
        authCookie.setMaxAge(COOKIE_MAX_AGE);
        authCookie.setPath("/");
        authCookie.setHttpOnly(true);
        authCookie.setSecure(false);
        response.addCookie(authCookie);

        Cookie userIdCookie = new Cookie(USER_ID_COOKIE_NAME, String.valueOf(userId));
        userIdCookie.setMaxAge(COOKIE_MAX_AGE);
        userIdCookie.setPath("/");
        userIdCookie.setHttpOnly(true);
        userIdCookie.setSecure(false);
        response.addCookie(userIdCookie);
    }

    public static String getAuthToken(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (AUTH_COOKIE_NAME.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    public static Integer getUserIdFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (USER_ID_COOKIE_NAME.equals(cookie.getName())) {
                    try {
                        return Integer.parseInt(cookie.getValue());
                    } catch (NumberFormatException e) {
                        return null;
                    }
                }
            }
        }
        return null;
    }

    public static boolean isValidToken(String token) {
        if (token == null || token.isEmpty()) {
            return false;
        }

        if (!tokenStore.containsKey(token)) {
            return false;
        }

        long tokenTime = tokenStore.get(token);
        long currentTime = System.currentTimeMillis();
        long maxAge = COOKIE_MAX_AGE * 1000L;

        return (currentTime - tokenTime) < maxAge;
    }

    public static Integer getUserIdFromToken(String token) {
        if (isValidToken(token)) {
            return tokenUserMap.get(token);
        }
        return null;
    }

    public static void clearAuthCookie(HttpServletResponse response) {
        Cookie authCookie = new Cookie(AUTH_COOKIE_NAME, "");
        authCookie.setMaxAge(0);
        authCookie.setPath("/");
        response.addCookie(authCookie);

        Cookie userIdCookie = new Cookie(USER_ID_COOKIE_NAME, "");
        userIdCookie.setMaxAge(0);
        userIdCookie.setPath("/");
        response.addCookie(userIdCookie);
    }

    public static void invalidateToken(String token) {
        if (token != null) {
            tokenStore.remove(token);
            tokenUserMap.remove(token);
        }
    }

    public static boolean hasValidCookie(HttpServletRequest request) {
        String token = getAuthToken(request);
        Integer userId = getUserIdFromCookie(request);

        return token != null && userId != null && isValidToken(token);
    }
}
