import os
from flask import Flask
from azure.storage.blob import BlobServiceClient
import pypyodbc as odbc

app = Flask(__name__)

# my shit.

approved_companies = ['635', '914']

# environment variables: account_name, account_key, sqlusername, sqlpassword. --> note put ; inbetween.
# account_name=sa4mywebapp
# account_key=6MykdaCJ20gM2YirxZpos+Pc4Q/emAXC5c+RdoUF2+ns8/HwEUHz0k73y/BEe8kIEOwbns69kAXl+AStNcCcoQ==
# sqlusername=osher
# sqlpassword=Password1234



@app.route('/<company_code>/<user>/<container>')
def auth(company_code, container, user):

    # check if the company code have the permission --> for the storage account.
    if company_code in approved_companies:
        container_name = container
        account_name = os.getenv('account_name')
        account_key = os.getenv('account_key')

        # Create a client to interact with blob storage
        connect_str = f"DefaultEndpointsProtocol=https;AccountName={account_name};AccountKey={account_key};EndpointSuffix=core.windows.net"
        blob_service_client = BlobServiceClient.from_connection_string(connect_str)

        # Use the client to connect to the container
        container_client = blob_service_client.get_container_client(container_name)

        # Get a list of all blob files in the container
        allowed_list_filename = None
        for blob in container_client.list_blobs():
            if blob.name == 'allowed.txt':
                allowed_list_filename = blob.name

        # Download each blob file to a local directory
        download_directory = "/app"
        blob_client = blob_service_client.get_blob_client(container=container_name, blob=allowed_list_filename)

        # Construct the local file path
        allowed_list_filename = 'allowed.py'
        local_path = f'{download_directory}/{allowed_list_filename}'

        # Download the blob to the local file path
        with open(local_path, "wb") as my_blob:
            download_stream = blob_client.download_blob()
            my_blob.write(download_stream.readall())

        # using the blob to check for permissions using the user we got.
        # first we import the file
        import allowed
        if user in allowed.name:
            index = allowed.name.index(user)
        else:
            return 'Invalid user'

        # sql config (name,conn,server dns)
        server = "ot-project-sql.database.windows.net"
        database = "ot-project-db"
        conn_string = 'Driver={ODBC Driver 18 for SQL Server};Server=tcp:'+server+',1433;Database='+database+';Uid='+os.getenv('sqlusername')+';Pwd='+os.getenv('sqlpassword')+';Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;'

        # creating the connection itself
        conn = odbc.connect(conn_string)

        # creating a sql query with the user allowed actions.

        sql = f'''
        SELECT {allowed.action1[index]}, {allowed.action2[index]}
        FROM SalesLT.{allowed.table[index]}
        '''

        # execute the query
        cursor = conn.cursor()
        cursor.execute(sql)
        dataset = cursor.fetchall()

        # delete the blob we have downloaded in order to use the sql and authenticate the user.
        os.remove(f'{download_directory}/{allowed_list_filename}')

        # print it for the client.
        return f'{dataset}'

    else:
        return "Not valid company."


if __name__ == '__main__':
    app.run(host='0.0.0.0')
