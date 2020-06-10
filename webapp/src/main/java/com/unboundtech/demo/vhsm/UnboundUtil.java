package com.unboundtech.demo.vhsm;

import com.dyadicsec.advapi.SDEKey;
import com.dyadicsec.advapi.SDESessionKey;
import java.util.Hashtable;

public class UnboundUtil {
  public static String DEFAULT_SDE_KEY_NAME = "unbound-fpe";
  public static boolean isUseCache = !Boolean.parseBoolean(System.getenv("UKC_DISABLE_SESSION_KEY_CACHE"));

  // cache sessions by tweak and purpose
  private static Hashtable<String, SDESessionKey> sessionCache = new Hashtable<String, SDESessionKey>();

  public static String getKeyFpeName() {
    return System.getenv("UKC_FPE_KEY");
  }

  public static String getActiveUsername() {
    return "so";
  }

  public static String getDefaultPassword() {
    return System.getenv("UKC_PASSWORD");
  }

  public static String getActivePartitionName() {
    return System.getenv("UKC_PARTITION");
  }

  public static SDEKey getSdeKey() {
    String keyName = System.getenv("UKC_FPE_KEY");
    if (keyName == null) {
      keyName = DEFAULT_SDE_KEY_NAME;
    }
    SDEKey sdeKey = SDEKey.findKey(keyName);

    if (sdeKey == null) {
      throw new RuntimeException(
          "Can't find key '"
              + keyName
              + "'. Verify that UKC client is configured and that key exists on partition.");
    }

    return sdeKey;
  }

  public static SDESessionKey getSdeSessionKey(String tweak, int purpose) {
    // try to used cached session
    String cacheKey = tweak + Integer.toString(purpose);
    SDESessionKey sk;
    if(isUseCache) {
      sk = sessionCache.get(cacheKey);
      if(sk != null) return sk;
    }

    SDEKey key = getSdeKey();
    try {
      sk = key.generateSessionKey(purpose, tweak);
      if(isUseCache) sessionCache.put(cacheKey, sk);
    } catch (Exception e) {
      if (e.getMessage().contains("C_DeriveKey")) {
        throw new RuntimeException(
            "Can't derive key. Make sure partition user:'user' has no password and restart the server.");
      }
      throw e;
    }
    return sk;
  }
}
