# 📊 SQL to Google Sheets Automation

This project automates the process of extracting data from a SQL Server database, processing it with Python, and updating a Google Sheet with the results.

✅ Requirements
Make sure you have the following installed:

Python 3.10 or newer

The libraries listed in requirements.txt

You can install dependencies with:

pip install -r requirements.txt

/*-----------------------------------------------*/

📁 Project Structure

project-root/
│
├── config/
│   ├── g_cred.json            # Your Google API credentials
│   └── g_creds_mold.txt       # Template for Google credentials
│
├── .env                       # Your environment variables
├── dot_env.txt                # Template for .env file
├── main.py                    # Main script
├── requirements.txt           # Required Python packages

/*-----------------------------------------------*/

## ⚙️ Setup Instructions

Follow the steps below to configure and run the project:

1. **Activate the virtual environment**  
   Make sure your environment is activated so that all required Python libraries are available.

2. **Add Google API credentials**  
   In the `config` folder, place your Google API credentials file named `g_cred.json`.  
   You can use the provided `g_creds_mold.txt` as a reference to structure your credentials correctly.

3. **Create a `.env` file**  
   In the project root (next to `main.py`), create a `.env` file containing:  
   - The **link to your target Google Sheet**
   - Your **SQL Server database connection credentials**  
   Use the provided `dot_env.txt` as a template.

4. **Run the script**  
   With the environment activated and all credentials set, execute the script:

   python main.py

/*-----------------------------------------------*/

📌 Notes
Make sure the Google Sheet is shared with the service account email found in your g_cred.json.

Keep your credentials secure and avoid committing sensitive data to GitHub.