from telethon.sync import TelegramClient

api_id = 'YOUR_API_ID'  # Replace with your API ID
api_hash = 'YOUR_API_HASH'  # Replace with your API Hash
channel = 'channel_username_or_id'  # Replace with channel username or ID

with TelegramClient('session_name', api_id, api_hash) as client:
    for message in client.iter_messages(channel):
        print(f"ID: {message.id} | Date: {message.date} | Sender: {message.sender_id} | Text: {message.text}")