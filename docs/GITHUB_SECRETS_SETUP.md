# GitHub Secrets Setup Guide
**Date:** 2025-01-27  
**DevOps Engineer:** AI DevOps Engineer  
**Project:** Yole Flutter App  
**Purpose:** Setup required secrets for CI/CD pipeline  

## Executive Summary

This guide provides step-by-step instructions for setting up the required GitHub secrets for the Flutter CI/CD pipeline. These secrets are essential for building, signing, and deploying the app to Google Play Console.

**Security Note:** Never commit these secrets to the repository. They must be stored securely in GitHub Secrets.

---

## 🔐 **REQUIRED GITHUB SECRETS**

### **1. PLAY_JSON**
**Purpose:** Google Play Console service account JSON key  
**Type:** String (JSON content)  
**Required for:** Uploading AAB to Play Console  

### **2. ANDROID_KEYSTORE**
**Purpose:** Android release keystore file  
**Type:** String (Base64 encoded)  
**Required for:** Signing release AAB  

### **3. KEY_PASS**
**Purpose:** Keystore key password  
**Type:** String (plain text)  
**Required for:** Signing release AAB  

### **4. STORE_PASS**
**Purpose:** Keystore store password  
**Type:** String (plain text)  
**Required for:** Signing release AAB  

---

## 📋 **SETUP INSTRUCTIONS**

### **Step 1: Access GitHub Secrets**

1. **Navigate to Repository Settings**
   - Go to your GitHub repository
   - Click on **Settings** tab
   - Click on **Secrets and variables** in the left sidebar
   - Click on **Actions**

2. **Access Repository Secrets**
   - Click on **New repository secret** button
   - You'll see a form to add new secrets

### **Step 2: Setup Google Play Console Service Account**

#### **2.1 Create Service Account**
1. **Go to Google Cloud Console**
   - Visit [Google Cloud Console](https://console.cloud.google.com/)
   - Select your project (or create one)

2. **Enable Google Play Developer API**
   - Go to **APIs & Services** > **Library**
   - Search for "Google Play Developer API"
   - Click **Enable**

3. **Create Service Account**
   - Go to **IAM & Admin** > **Service Accounts**
   - Click **Create Service Account**
   - Name: `yole-play-console`
   - Description: `Service account for Yole app deployment`
   - Click **Create and Continue**

4. **Grant Permissions**
   - Role: **Service Account User**
   - Click **Continue**

5. **Create Key**
   - Click on the created service account
   - Go to **Keys** tab
   - Click **Add Key** > **Create new key**
   - Type: **JSON**
   - Click **Create**
   - Download the JSON file

#### **2.2 Link to Google Play Console**
1. **Go to Google Play Console**
   - Visit [Google Play Console](https://play.google.com/console/)
   - Select your app

2. **Setup API Access**
   - Go to **Setup** > **API access**
   - Click **Link project**
   - Select your Google Cloud project
   - Click **Link**

3. **Grant Permissions**
   - Find your service account
   - Click **Grant access**
   - Permissions:
     - **View app information and download bulk reports**
     - **Manage production releases**
     - **Manage testing track releases**
   - Click **Apply**

#### **2.3 Add PLAY_JSON Secret**
1. **Open the downloaded JSON file**
2. **Copy the entire JSON content**
3. **Add to GitHub Secrets**
   - Name: `PLAY_JSON`
   - Value: Paste the entire JSON content
   - Click **Add secret**

### **Step 3: Setup Android Keystore**

#### **3.1 Generate Keystore (if not exists)**
```bash
# Generate new keystore
keytool -genkey -v -keystore yole-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# You'll be prompted for:
# - Keystore password (this will be STORE_PASS)
# - Key password (this will be KEY_PASS)
# - Your name, organization, etc.
```

#### **3.2 Encode Keystore to Base64**
```bash
# On macOS/Linux
base64 -i yole-release-key.jks -o keystore-base64.txt

# On Windows (PowerShell)
[Convert]::ToBase64String([IO.File]::ReadAllBytes("yole-release-key.jks")) | Out-File -FilePath "keystore-base64.txt" -Encoding ASCII
```

#### **3.3 Add Keystore Secrets**
1. **Add ANDROID_KEYSTORE Secret**
   - Name: `ANDROID_KEYSTORE`
   - Value: Copy content from `keystore-base64.txt`
   - Click **Add secret**

2. **Add KEY_PASS Secret**
   - Name: `KEY_PASS`
   - Value: The key password you set during keystore generation
   - Click **Add secret**

3. **Add STORE_PASS Secret**
   - Name: `STORE_PASS`
   - Value: The keystore password you set during keystore generation
   - Click **Add secret**

### **Step 4: Verify Secrets Setup**

#### **4.1 Check Secret Names**
Ensure all secrets are added with exact names:
- ✅ `PLAY_JSON`
- ✅ `ANDROID_KEYSTORE`
- ✅ `KEY_PASS`
- ✅ `STORE_PASS`

#### **4.2 Test Pipeline**
1. **Create a test commit**
   ```bash
   git commit --allow-empty -m "release: test CI/CD pipeline"
   git push origin main
   ```

2. **Monitor GitHub Actions**
   - Go to **Actions** tab in your repository
   - Watch the workflow execution
   - Check for any secret-related errors

---

## 🔒 **SECURITY BEST PRACTICES**

### **Secret Management**
- **Never commit secrets** to the repository
- **Use environment-specific secrets** for different environments
- **Rotate secrets regularly** (every 90 days)
- **Limit secret access** to necessary team members only
- **Monitor secret usage** in GitHub Actions logs

### **Keystore Security**
- **Store keystore securely** (encrypted backup)
- **Use strong passwords** (minimum 12 characters)
- **Limit keystore access** to release managers only
- **Document keystore location** for team access
- **Create backup copies** in secure locations

### **Service Account Security**
- **Limit permissions** to minimum required
- **Monitor service account usage** in Google Cloud Console
- **Rotate service account keys** regularly
- **Use least privilege principle** for access
- **Audit service account activities** regularly

---

## 🚨 **TROUBLESHOOTING**

### **Common Issues**

#### **1. PLAY_JSON Secret Issues**
```
Error: Invalid service account JSON
```
**Solution:**
- Verify JSON content is complete and valid
- Check service account has proper permissions
- Ensure Google Play Developer API is enabled

#### **2. Keystore Signing Issues**
```
Error: Keystore not found or invalid
```
**Solution:**
- Verify ANDROID_KEYSTORE is properly base64 encoded
- Check KEY_PASS and STORE_PASS are correct
- Ensure keystore file is not corrupted

#### **3. Play Console Upload Issues**
```
Error: Insufficient permissions
```
**Solution:**
- Verify service account has proper Play Console permissions
- Check app package name matches in Play Console
- Ensure service account is linked to correct project

### **Debug Steps**
1. **Check secret names** are exactly as specified
2. **Verify secret values** are properly formatted
3. **Test locally** with the same secrets
4. **Check GitHub Actions logs** for detailed error messages
5. **Verify Google Cloud project** settings

---

## 📊 **SECRET VALIDATION**

### **Validation Checklist**
- [ ] **PLAY_JSON** - Valid JSON with proper service account permissions
- [ ] **ANDROID_KEYSTORE** - Base64 encoded keystore file
- [ ] **KEY_PASS** - Correct key password
- [ ] **STORE_PASS** - Correct keystore password
- [ ] **All secrets** added to GitHub repository settings
- [ ] **Service account** linked to Google Play Console
- [ ] **Keystore** generated with proper alias and validity
- [ ] **Test pipeline** runs successfully

### **Verification Commands**
```bash
# Test keystore locally
keytool -list -v -keystore yole-release-key.jks -alias upload

# Test service account JSON
cat service-account.json | jq .

# Test base64 encoding
base64 -d keystore-base64.txt | file -
```

---

## 📝 **MAINTENANCE SCHEDULE**

### **Regular Tasks**
- **Monthly:** Review secret usage and access
- **Quarterly:** Rotate service account keys
- **Bi-annually:** Review and update keystore passwords
- **Annually:** Audit all secrets and permissions

### **Emergency Procedures**
- **Secret Compromise:** Immediately rotate affected secrets
- **Keystore Loss:** Use backup keystore or regenerate
- **Service Account Issues:** Create new service account with same permissions
- **Access Issues:** Contact repository administrators

---

## 📄 **REFERENCE DOCUMENTS**

- **GitHub Secrets Documentation** - [GitHub Docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- **Google Play Console API** - [Google Play Console API](https://developers.google.com/android-publisher)
- **Android App Signing** - [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- **Flutter CI/CD Best Practices** - [Flutter CI/CD](https://docs.flutter.dev/deployment/ci)

---

## 📞 **SUPPORT CONTACTS**

**DevOps Team:** devops@yole.com  
**Security Team:** security@yole.com  
**Release Team:** releases@yole.com  

**Emergency Contact:** +1-XXX-XXX-XXXX (24/7)

---

**Document Status:** ACTIVE  
**Last Updated:** 2025-01-27  
**Next Review:** 2025-04-27

