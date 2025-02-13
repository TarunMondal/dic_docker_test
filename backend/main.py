from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import uvicorn

app = FastAPI()

# Allow frontend to call backend (CORS issue fix)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change this in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Request model
class NameRequest(BaseModel):
    name: str

# ✅ Ensure this is a POST request
@app.post("/greet")
def greet(request: NameRequest):
    return {"message": f"Hello {request.name}"}

# Run FastAPI
# if __name__ == "__main__":
#     uvicorn.run(app, host="0.0.0.0", port=8000)
