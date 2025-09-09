import pandas as pd
df = pd.read_csv(r'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\sessions.csv')

df['end_time'] = df['end_time'].fillna(df['start_time'])   # if end time missing it keep as start tiem only
df = df.drop_duplicates(subset=['event_id'], keep='first') # duplicates are removed by means of event_id

df['invalid_flag'] = df.apply(
    lambda row: 1 if pd.to_datetime(row['end_time']) < pd.to_datetime(row['start_time']) else 0, axis=1  # Flag invalid (end before start)
)
df.to_csv("sessions_cleaned.csv", index=False)
