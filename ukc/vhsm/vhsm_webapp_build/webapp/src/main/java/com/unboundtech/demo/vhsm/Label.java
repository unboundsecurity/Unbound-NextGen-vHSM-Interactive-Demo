package com.unboundtech.demo.vhsm;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@JsonIgnoreProperties(value = {"clientID"})
public class Label {
  public String clientID;
  public String fullName;
  public String addressLine1;
  public String addressLine2;
  public String city;
  public String region;
  public String postalCode;
  public String country;

  public String toJsonShort() {
    String[] attrs = {
      this.fullName,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.region,
      this.postalCode,
      this.country
    };
    ObjectMapper mapper = new ObjectMapper();

    String json = "";
    try {
      json = mapper.writeValueAsString(attrs);
    } catch (Exception e) {
      json = e.toString();
    }
    return json;
  }

  public String toJson() {
    ObjectMapper mapper = new ObjectMapper();

    String json = "";
    try {
      json = mapper.writeValueAsString(this);
    } catch (Exception e) {
      json = e.toString();
    }
    return json;
  }
}
