package com.unboundtech.demo.vhsm;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.server.ServletWebServerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.embedded.tomcat.TomcatConnectorCustomizer;
import java.security.Security;
import org.apache.coyote.http11.Http11NioProtocol;
import org.apache.catalina.connector.Connector;
import com.dyadicsec.provider.DYCryptoProvider;

@SpringBootApplication
public class VHSMDemoApplication {

  @Bean
  public ServletWebServerFactory servContainer() {

    // Avoid registration in build mode when ukc is not initialized
    // this causes exception during tests
    // this allows building without setting up a UKC system
    if(!("true".equals(System.getenv("BUILD_MODE")))) {
      Security.addProvider(new DYCryptoProvider(System.getenv("UKC_PARTITION")));
    }

    TomcatServletWebServerFactory tomcat = new TomcatServletWebServerFactory();

    if("true".equals(System.getenv("VHSM_DEMO_USE_HTTPS"))) {
      System.out.println("Using HTTPS");
      TomcatConnectorCustomizer tomcatConnectorCustomizer =
          new TomcatConnectorCustomizer() {
            @Override
            public void customize(Connector connector) {
              String keyName = System.getenv("VHSM_DEMO_TLS_KEY_ALIAS");
              connector.setPort(8443);
              connector.setScheme("https");
              connector.setSecure(true);
              Http11NioProtocol protocol = (Http11NioProtocol) connector.getProtocolHandler();

              protocol.setSSLEnabled(true);
              protocol.setKeystoreType("PKCS11");
              protocol.setKeystoreProvider("DYADIC");
              protocol.setMaxThreads(150);
              protocol.setKeyAlias(keyName);
              String sslProtocol = System.getenv("VHSM_DEMO_SSL_PROTOCOL");
              protocol.setSSLProtocol(sslProtocol);
              // protocol.setClietAuth(Boolean.toString(false));
              protocol.setSSLVerifyClient(Boolean.toString(false));

              // protocol.setKeystoreFile(keystorePath);
              protocol.setKeystorePass("");
              // client must be authenticated (the cert he sends should be in our trust store)
              // protocol.setSSLVerifyClient(Boolean.toString(true));
              // protocol.setTruststoreFile(truststorePath);
              // protocol.setTruststorePass(truststorePass);
              // protocol.setKeyAlias("APP");
            }
          };
      tomcat.addConnectorCustomizers(tomcatConnectorCustomizer);
    }

    return tomcat;
  }

  public static void main(String[] args) {
    SpringApplication.run(VHSMDemoApplication.class, args);
  }
}
