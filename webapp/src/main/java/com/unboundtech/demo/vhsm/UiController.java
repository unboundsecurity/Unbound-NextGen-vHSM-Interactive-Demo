package com.unboundtech.demo.vhsm;

import com.dyadicsec.advapi.SDESessionKey;
import com.dyadicsec.advapi.SDEKey;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class UiController {
  /*
    This method takes the text to be encoded, the width and height of the QR Code,
    and returns the QR Code in the form of a byte array.
  */
  private String getQRCodeImage(String text, int width, int height)
      throws WriterException, IOException {
    final Map<EncodeHintType, Object> encodingHints = new HashMap<>();
    encodingHints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
    encodingHints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
    QRCodeWriter qrCodeWriter = new QRCodeWriter();
    BitMatrix bitMatrix =
        qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, width, height, encodingHints);

    ByteArrayOutputStream pngOutputStream = new ByteArrayOutputStream();
    MatrixToImageWriter.writeToStream(bitMatrix, "PNG", pngOutputStream);
    byte[] pngData = pngOutputStream.toByteArray();
    byte[] encoded = Base64.getEncoder().encode(pngData);
    return new String(encoded);
  }

  @GetMapping("/labels/new")
  public String newLabelForm(Model model) {
    model.addAttribute("label", new Label());
    return "newLabel";
  }

  @GetMapping("/tokenization")
  public String apiTester(Model model) {
    String partitionName = UnboundUtil.getActivePartitionName();
    String key = UnboundUtil.getKeyFpeName();
    model.addAttribute("keyname", key);
    model.addAttribute("activePartition", partitionName);
    model.addAttribute("activeKeyMessage", "Using key '" + key
    + "' on partition '" + partitionName + "'");
    return "tokenization";
  }

  @GetMapping("/")
  public String home(Model model) {
    return "home";
  }

  @PostMapping("/labels")
  public String createLabel(@ModelAttribute Label label, Model model) {
    String json = label.toJsonShort();
    String base64 = "";
    String encrypted = "";
    String error = "";
    try {
      SDESessionKey sk = UnboundUtil.getSdeSessionKey(label.clientID, SDEKey.PURPOSE_STRING_ENC);
      encrypted = sk.encryptTypePreserving(json, true);
      base64 = getQRCodeImage(encrypted, 400, 400);
    } catch (Exception e) {
      System.out.println(e.toString());
      error = e.getMessage();
    }
    model.addAttribute("qrBase64", base64);
    model.addAttribute("encrypted", encrypted);
    model.addAttribute("json", json);
    model.addAttribute("error", error);
    return "createLabel";
  }

  @GetMapping(path = "/enc")
  public String enc(
      @RequestParam(name = "tweak", defaultValue = "") String tweak,
      @RequestParam(name = "bmponly", defaultValue = "true") Boolean bmponly,
      @RequestParam(name = "text", defaultValue = "shalom") String text,
      Model model) {
    String base64 = "";
    String encrypted = "";
    String error = "";
    try {
      SDESessionKey sk = UnboundUtil.getSdeSessionKey(tweak, SDEKey.PURPOSE_STRING_ENC );
      encrypted = sk.encryptTypePreserving(text, bmponly);
      System.out.println(encrypted);
      base64 = getQRCodeImage(encrypted, 400, 400);
    } catch (Exception e) {
      System.out.println(e.toString());
    }
    model.addAttribute("qrBase64", base64);
    model.addAttribute("encrypted", encrypted);
    return "qr";
  }

  @GetMapping("/logs")
  public String logs() {
    return "logs";
  }

  @GetMapping("/webadmin")
  public String getTrust(Model model) {
    String partitionName = UnboundUtil.getActivePartitionName();
    String userName = UnboundUtil.getActiveUsername();
    String password = UnboundUtil.getDefaultPassword();
    String userPartitionPath = ":8082/login?partition=" + partitionName + "&user=" + userName + "&password=" + password + "&autoLogin=false";
    String rootPartitionPath = ":8082/login?partition=root&user=so&password=" + password + "&autoLogin=false";

    model.addAttribute("userPartitionPath", userPartitionPath);
    model.addAttribute("rootPartitionPath", rootPartitionPath);

    return "webadmin";
  }

  @GetMapping("/resources")
  public String getResources() {
    return "resources";
  }

  @GetMapping("/cli")
  public String getCli() {
    return "cli";
  }
}
