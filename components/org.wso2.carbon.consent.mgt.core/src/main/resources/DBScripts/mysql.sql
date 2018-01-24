CREATE TABLE CM_PII_CATEGORY (
  ID           INTEGER AUTO_INCREMENT,
  NAME         VARCHAR(255) NOT NULL,
  DESCRIPTION  VARCHAR(1023),
  IS_SENSITIVE INTEGER      NOT NULL,
  PRIMARY KEY (ID)
);

CREATE TABLE CM_RECEIPT (
  CONSENT_RECEIPT_ID      VARCHAR(255) NOT NULL,
  VERSION                 VARCHAR(255) NOT NULL,
  JURISDICTION            VARCHAR(255) NOT NULL,
  CONSENT_TIMESTAMP       TIMESTAMP    NOT NULL,
  COLLECTION_METHOD       VARCHAR(255) NOT NULL,
  LANGUAGE                VARCHAR(255) NOT NULL,
  PII_PRINCIPAL_ID        VARCHAR(255) NOT NULL,
  PRINCIPAL_TENANT_DOMAIN VARCHAR(255),
  POLICY_URL              VARCHAR(255) NOT NULL,
  STATE                   VARCHAR(255) NOT NULL,
  PRIMARY KEY (CONSENT_RECEIPT_ID)
);

CREATE TABLE CM_PURPOSE (
  ID          INTEGER AUTO_INCREMENT,
  NAME        VARCHAR(255) NOT NULL,
  DESCRIPTION VARCHAR(1023),
  PRIMARY KEY (ID)
);

CREATE TABLE CM_PURPOSE_CATEGORY (
  ID          INTEGER AUTO_INCREMENT,
  NAME        VARCHAR(255) NOT NULL,
  DESCRIPTION VARCHAR(1023),
  PRIMARY KEY (ID)
);

CREATE TABLE CM_RECEIPT_SP_ASSOC (
  ID                 INTEGER      AUTO_INCREMENT,
  CONSENT_RECEIPT_ID VARCHAR(255) NOT NULL,
  SP_NAME            VARCHAR(255) NOT NULL,
  SP_TENANT_DOMAIN   VARCHAR(255) DEFAULT 'carbon.super',
  UNIQUE KEY (CONSENT_RECEIPT_ID, SP_NAME, SP_TENANT_DOMAIN),
  PRIMARY KEY (ID)
);

CREATE TABLE CM_SP_PURPOSE_ASSOC (
  ID                     INTEGER AUTO_INCREMENT,
  RECEIPT_SP_ASSOC       INTEGER      NOT NULL,
  PURPOSE_ID             INTEGER      NOT NULL,
  CONSENT_TYPE           VARCHAR(255) NOT NULL,
  IS_PRIMARY_PURPOSE     INTEGER      NOT NULL,
  TERMINATION            VARCHAR(255) NOT NULL,
  THIRD_PARTY_DISCLOSURE INTEGER      NOT NULL,
  THIRD_PARTY_NAME       VARCHAR(255) NOT NULL,
  UNIQUE KEY (RECEIPT_SP_ASSOC, PURPOSE_ID),
  PRIMARY KEY (ID)
);

CREATE TABLE CM_SP_PURPOSE_PURPOSE_CAT_ASSOC (
  SP_PURPOSE_ASSOC_ID INTEGER NOT NULL,
  PURPOSE_CATEGORY_ID INTEGER NOT NULL,
  UNIQUE KEY (SP_PURPOSE_ASSOC_ID, PURPOSE_CATEGORY_ID)
);

CREATE TABLE CM_SP_PURPOSE_PII_CATEGORY_ASSOC (
  SP_PURPOSE_ASSOC_ID INTEGER NOT NULL,
  PII_CATEGORY_ID     INTEGER NOT NULL,
  UNIQUE KEY (SP_PURPOSE_ASSOC_ID, PII_CATEGORY_ID)
);

CREATE TABLE CM_CONSENT_RECEIPT_PROPERTY (
  CONSENT_RECEIPT_ID VARCHAR(255)  NOT NULL,
  NAME               VARCHAR(255)  NOT NULL,
  VALUE              VARCHAR(1023) NOT NULL,
  UNIQUE KEY (CONSENT_RECEIPT_ID, NAME)
);
ALTER TABLE CM_RECEIPT_SP_ASSOC
  ADD CONSTRAINT CM_RECEIPT_SP_ASSOC_fk0 FOREIGN KEY (CONSENT_RECEIPT_ID) REFERENCES CM_RECEIPT (CONSENT_RECEIPT_ID);

ALTER TABLE CM_SP_PURPOSE_ASSOC
  ADD CONSTRAINT CM_SP_PURPOSE_ASSOC_fk0 FOREIGN KEY (RECEIPT_SP_ASSOC) REFERENCES CM_RECEIPT_SP_ASSOC (ID);

ALTER TABLE CM_SP_PURPOSE_ASSOC
  ADD CONSTRAINT CM_SP_PURPOSE_ASSOC_fk1 FOREIGN KEY (PURPOSE_ID) REFERENCES CM_PURPOSE (ID);

ALTER TABLE CM_SP_PURPOSE_PURPOSE_CAT_ASSOC
  ADD CONSTRAINT CM_SP_PURPOSE_PURPOSE_CAT_ASSOC_fk0 FOREIGN KEY (SP_PURPOSE_ASSOC_ID) REFERENCES CM_SP_PURPOSE_ASSOC (ID);

ALTER TABLE CM_SP_PURPOSE_PURPOSE_CAT_ASSOC
  ADD CONSTRAINT CM_SP_PURPOSE_PURPOSE_CAT_ASSOC_fk1 FOREIGN KEY (PURPOSE_CATEGORY_ID) REFERENCES CM_PURPOSE_CATEGORY (ID);

ALTER TABLE CM_SP_PURPOSE_PII_CATEGORY_ASSOC
  ADD CONSTRAINT CM_SP_PURPOSE_PII_CATEGORY_ASSOC_fk0 FOREIGN KEY (SP_PURPOSE_ASSOC_ID) REFERENCES CM_SP_PURPOSE_ASSOC (ID);

ALTER TABLE CM_SP_PURPOSE_PII_CATEGORY_ASSOC
  ADD CONSTRAINT CM_SP_PURPOSE_PII_CATEGORY_ASSOC_fk1 FOREIGN KEY (PII_CATEGORY_ID) REFERENCES CM_PII_CATEGORY (ID);

ALTER TABLE CM_CONSENT_RECEIPT_PROPERTY
  ADD CONSTRAINT CM_CONSENT_RECEIPT_PROPERTY_fk0 FOREIGN KEY (CONSENT_RECEIPT_ID) REFERENCES CM_RECEIPT (CONSENT_RECEIPT_ID);