import os
from flask import Flask
from azure.storage.blob import BlobServiceClient
import pypyodbc as odbc

app = Flask(__name__)

approved_companies = ['635', '914']

@app.route('/<company_code>/<user>/<container>')
def auth(company_code, container, user):
    if company_code in approved_companies:
        container_name = container
        account_name = os.getenv('account_name')
        account_key = os.getenv('storageAccountKey')  # Updated variable name

        connect_str = f"DefaultEndpointsProtocol=https;AccountName={account_name};AccountKey={account_key};EndpointSuffix=core.windows.net"
        blob_service_client = BlobServiceClient.from_connection_string(connect_str)

        container_client = blob_service_client.get_container_client(container_name)

        allowed_list_filename = None
        for blob in container_client.list_blobs():
            if blob.name == 'allowed.txt':
                allowed_list_filename = blob.name

        download_directory = "/app"
        blob_client = blob_service_client.get_blob_client(container=container_name, blob=allowed_list_filename)

        allowed_list_filename = 'allowed.py'
        local_path = f'{download_directory}/{allowed_list_filename}'

        with open(local_path, "wb") as my_blob:
            download_stream = blob_client.download_blob()
            my_blob.write(download_stream.readall())

        import allowed
        if user in allowed.name:
            index = allowed.name.index(user)
        else:
            return 'Invalid user'

        server = "ot-app-sql.database.windows.net"
        database = "ot-app-db"
        conn_string = 'Driver={ODBC Driver 18 for SQL Server};Server=tcp:'+server+',1433;Database='+database+';Uid='+os.getenv('sqlusername')+';Pwd='+os.getenv('sqlpassword')+';Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;'

        conn = odbc.connect(conn_string)

        sql = f'''
        SELECT {allowed.action1[index]}, {allowed.action2[index]}
        FROM SalesLT.{allowed.table[index]}
        '''

        cursor = conn.cursor()
        cursor.execute(sql)
        dataset = cursor.fetchall()

        os.remove(f'{download_directory}/{allowed_list_filename}')

        return f'{dataset}'
    else:
        return "Not valid company."

if __name__ == '__main__':
    app.run(host='0.0.0.0')
