import os
import zipfile
import shutil

structure = {
    "config": ["config.php", "database.php", "constants.php", "ai_config.php"],
    "database": ["schema.sql", "seed.sql"],
    "includes": ["auth.php", "rbac.php", "functions.php", "language.php", "ai_assistant.php", "header.php", "sidebar.php", "footer.php", "pwa.php"],
    "auth": ["logout.php"],
    "pages": ["dashboard.php", "pos.php", "customers.php", "inventory.php", "purchases.php", "suppliers.php", "services.php", "bills.php", "accounts.php", "reports.php", "recycle.php", "backup.php", "settings.php", "ai.php", "super_admin.php", "shifts.php", "transfers.php", "installations.php"],
    "api": ["pos_search.php", "pos_checkout.php", "pos_imei.php", "customer_quick_add.php", "repair_list.php", "repair_create.php", "repair_detail.php", "repair_update.php", "repair_add_part.php", "bill_pay.php", "bill_history.php", "accounting_monthly.php", "accounting_transactions.php", "vat_return.php", "ai_query.php", "ai_insights.php", "backup_create.php", "backup_list.php", "backup_download.php", "backup_restore.php", "backup_delete.php", "super_admin.php", "shift_open.php", "shift_close.php", "transfer_create.php", "transfer_receive.php"],
    "print": ["receipt.php", "job_card.php", "invoice_a4.php"],
    "assets/css": ["app.css"],
    "assets/js": ["app.js", "ai_widget.js"],
    "assets/icons": [],
    "assets": ["manifest.json"],
    "install": ["step7_setup.php"],
    "": ["install.php", "login.php", "index.php", "offline.html", "service-worker.js"]
}

base_dir = "/mnt/data/rst-erp"
os.makedirs(base_dir, exist_ok=True)

for folder, files in structure.items():
    folder_path = os.path.join(base_dir, folder)
    os.makedirs(folder_path, exist_ok=True)
    for file_name in files:
        file_path = os.path.join(folder_path, file_name)
        with open(file_path, "w") as f:
            if file_name.endswith(".php"):
                f.write(f"<?php\n// File: {file_name}\n// Please insert the actual code for this step here\n")
            elif file_name.endswith(".html"):
                f.write(f"<!-- File: {file_name} -->\n")
            elif file_name.endswith(".sql"):
                f.write(f"-- File: {file_name}\n")
            elif file_name.endswith(".js"):
                f.write(f"// File: {file_name}\n")
            elif file_name.endswith(".css"):
                f.write(f"/* File: {file_name} */\n")
            else:
                f.write("")

zip_path = "/mnt/data/rst-erp-structure.zip"
shutil.make_archive("/mnt/data/rst-erp-structure", 'zip', base_dir)
print(f"Generated {zip_path}")