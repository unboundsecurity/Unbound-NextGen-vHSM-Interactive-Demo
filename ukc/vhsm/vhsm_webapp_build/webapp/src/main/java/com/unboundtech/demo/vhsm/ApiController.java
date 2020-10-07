package com.unboundtech.demo.vhsm;

import com.dyadicsec.advapi.SDEKey;
import com.dyadicsec.advapi.SDESessionKey;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.Base64;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class ApiController {

  public static final byte[] DEFAULT_AAD = new byte[0];
  public static final String DEFAULT_TWEAK = "1234ABCD!";

  public static void trustSelfSignedSSL() {
    try {
      SSLContext ctx = SSLContext.getInstance("TLS");
      X509TrustManager tm =
          new X509TrustManager() {

            public void checkClientTrusted(X509Certificate[] xcs, String string)
                throws CertificateException {}

            public void checkServerTrusted(X509Certificate[] xcs, String string)
                throws CertificateException {}

            public X509Certificate[] getAcceptedIssuers() {
              return null;
            }
          };
      ctx.init(null, new TrustManager[] {tm}, null);
      SSLContext.setDefault(ctx);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  @GetMapping("/key")
  public String key(@RequestParam(name = "tweak", defaultValue = "") String tweak) {
    try {
      SDESessionKey sk = UnboundUtil.getSdeSessionKey(tweak, SDEKey.PURPOSE_STRING_ENC);
      byte[] material = sk.getKeyMaterial();
      return Util.bytesToHex(material);
    } catch (Exception e) {
      System.out.println(e.getMessage());
      throw e;
    }
  }

  @PostMapping(path = "/tokenize", consumes = "text/plain", produces = "text/plain")
  public String tokenize(@RequestBody String clearText) {
    SDESessionKey sk = UnboundUtil.getSdeSessionKey(DEFAULT_TWEAK, SDEKey.PURPOSE_STRING_ENC);
    return sk.encryptTypePreserving(clearText, true);
  }

  @PostMapping(path = "/detokenize", consumes = "text/plain", produces = "text/plain")
  public String detokenize(@RequestBody String cypherText) {
    SDESessionKey sk = UnboundUtil.getSdeSessionKey(DEFAULT_TWEAK, SDEKey.PURPOSE_STRING_ENC);
    return sk.decryptTypePreserving(cypherText, true);
  }

  @PostMapping(path = "/tokenizeCreditCard", consumes = "text/plain", produces = "text/plain")
  public String tokenizeCreditCard(@RequestBody String clearText) {
    SDESessionKey sk = UnboundUtil.getSdeSessionKey(DEFAULT_TWEAK, SDEKey.PURPOSE_CREDIT_CARD_ENC);
    return sk.encryptCreditCard(clearText.trim());
  }

  @PostMapping(path = "/detokenizeCreditCard", consumes = "text/plain", produces = "text/plain")
  public String detokenizeCreditCard(@RequestBody String cypherText) {
    SDESessionKey sk = UnboundUtil.getSdeSessionKey(DEFAULT_TWEAK, SDEKey.PURPOSE_CREDIT_CARD_ENC);
    return sk.decryptCreditCard(cypherText.trim());
  }

  @PostMapping(path = "/tokenizeEmail", consumes = "text/plain", produces = "text/plain")
  public String tokenizeEmail(@RequestBody String clearText) {
    SDESessionKey sk = UnboundUtil.getSdeSessionKey(DEFAULT_TWEAK, SDEKey.PURPOSE_EMAIL_ENC);
    // String txt = sk.encryptEMailAddress("adam.ilan@unboundtech.com", 100);
    // return txt;
    return sk.encryptEMailAddress(clearText.trim(), 50);
  }

  @PostMapping(path = "/detokenizeEmail", consumes = "text/plain", produces = "text/plain")
  public String detokenizeEmail(@RequestBody String cypherText) {
    SDESessionKey sk = UnboundUtil.getSdeSessionKey(DEFAULT_TWEAK, SDEKey.PURPOSE_EMAIL_ENC);
    return sk.decryptEMailAddress(cypherText.trim());
  }

  @PostMapping(path = "/tokenizeSSN", consumes = "text/plain", produces = "text/plain")
  public String tokenizeSSN(@RequestBody String clearText) {
    SDESessionKey sk = UnboundUtil.getSdeSessionKey(DEFAULT_TWEAK, SDEKey.PURPOSE_SSN_ENC);
    return sk.encryptSSN(clearText.trim(), "###-##-####");
  }

  @PostMapping(path = "/detokenizeSSN", consumes = "text/plain", produces = "text/plain")
  public String detokenizeSSN(@RequestBody String cypherText) {
    SDESessionKey sk = UnboundUtil.getSdeSessionKey(DEFAULT_TWEAK, SDEKey.PURPOSE_SSN_ENC);
    return sk.decryptSSN(cypherText.trim(), "###-##-####"  );
  }

  @PostMapping(path = "/tokenizePhone", consumes = "text/plain", produces = "text/plain")
  public String tokenizePhone(@RequestBody String clearText) {
    SDESessionKey sk = UnboundUtil.getSdeSessionKey(DEFAULT_TWEAK, SDEKey.PURPOSE_US_PHONE_ENC);
    return sk.encryptUSPhone(clearText.trim(), "###-###-####");
  }

  @PostMapping(path = "/detokenizePhone", consumes = "text/plain", produces = "text/plain")
  public String detokenizePhone(@RequestBody String cypherText) {
    SDESessionKey sk = UnboundUtil.getSdeSessionKey(DEFAULT_TWEAK, SDEKey.PURPOSE_US_PHONE_ENC);
    return sk.decryptUSPhone(cypherText.trim(), "###-###-####"  );
  }

  @PostMapping(path = "/encrypt", consumes = "text/plain", produces = "text/plain")
  public String encrypt(@RequestBody String clearText) {
    SDEKey key = UnboundUtil.getSdeKey();
    byte[] in = clearText.getBytes(StandardCharsets.UTF_8); // Java 7+ only
    byte[] cypher = key.encrypt(DEFAULT_AAD, in);
    String encoded = Base64.getEncoder().encodeToString(cypher);
    return encoded;
  }

  @PostMapping(path = "/decrypt", consumes = "text/plain", produces = "text/plain")
  public String decrypt(@RequestBody String cypherBase64) {
    byte[] decoded = Base64.getDecoder().decode(cypherBase64);
    SDEKey key = UnboundUtil.getSdeKey();
    byte[] clearTextBytes = key.decrypt(DEFAULT_AAD, decoded);
    String clearText = new String(clearTextBytes, StandardCharsets.UTF_8);
    return clearText;
  }

  @GetMapping(value = "/server-ca.p7b", produces = "application/x-pkcs7-certificates")
  public @ResponseBody byte[] getServerCa() throws IOException {
    try {
      // HttpsURLConnection.setDefaultHostnameVerifier((hostname, session) -> true);
      trustSelfSignedSSL();
      final String uri = "https://ukc-ep/api/v1/server-ca.p7b";
      RestTemplate restTemplate = new RestTemplate();
      byte[] result = restTemplate.getForObject(uri, byte[].class);
      return result;
    } catch (Exception e) {
      System.out.println(e.getMessage());
      throw e;
    }
  }
}
