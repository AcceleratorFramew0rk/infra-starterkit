### **tfignite: Accelerate Your Terraform Deployments 🚀**  

#### **Overview**  
**`tfignite`** is a powerful command-line tool designed to **automate and accelerate Terraform deployments**. It simplifies running Terraform **`init`**, **`plan`**, and **`apply`** with flexible configuration options, making infrastructure provisioning faster and more efficient.  

With **`tfignite`**, you can:  
✅ **Specify the Terraform configuration directory** for execution  
✅ **Pass custom `-var` values** dynamically  
✅ **Ensure smooth execution** of `init`, `plan`, and `apply` in one streamlined workflow  

---

#### **Features**  
- **🔥 One-Command Execution**: Run `terraform init`, `plan`, and `apply` seamlessly  
- **📂 Configurable Directory Support**: Execute Terraform commands in any specified path  
- **🔧 Dynamic Variable Injection**: Pass `-var` arguments for customized deployments  
- **🚀 Fast & Automated**: Speeds up Terraform workflows for CI/CD and automation  

---

#### **Usage**  
##### **Basic Execution**  
```bash
tfignite apply -path=/path/to/terraform/config -var="region=westus" -var="instance_count=3"
```
- Runs **`terraform init`**, **`terraform plan`**, and **`terraform apply -auto-approve`**  
- Uses Terraform configuration located in `/path/to/terraform/config`  
- Passes `-var="region=westus"` and `-var="instance_count=3"` dynamically  

##### **Example with Debug Mode**  
```bash
tfignite plan -path=./infra -vars="env=prod"
```

- Runs **`terraform init`** and **`terraform plan`**  
- Uses Terraform configuration located in `./infra` directory  
- Passes `-var="env=prod"` dynamically

---

#### **Behind the Scenes (What `tfignite` Does)**
1️⃣ **Change to specified Terraform configuration directory**  
2️⃣ **Run `terraform init`** to initialize the backend and providers  
3️⃣ **Run `terraform plan`** to preview changes  
4️⃣ **Run `terraform apply -auto-approve`** for automatic deployment  

---

#### **Why tfignite?**  
🚀 **Faster Deployments** – Eliminates repetitive Terraform command inputs  
🔄 **Automation-Friendly** – Ideal for CI/CD pipelines and infrastructure automation  
🛠️ **Customizable** – Supports variable injection and custom Terraform directories  

---

### **Get Started with tfignite Today! 🔥**  

