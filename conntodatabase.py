from urllib.parse import quote_plus
import sqlalchemy as sal

user = "root"
password = quote_plus("Anchor@161616")  # encode special chars
host = "localhost"
port = 3306
database = "retail_analysis"

engine = sal.create_engine(
    f"mysql+pymysql://{user}:{password}@{host}:{port}/{database}"
)

with engine.connect() as conn:
    result = conn.execute(sal.text("SELECT VERSION();"))
    print("Connected to MySQL version:", result.fetchone()[0])
