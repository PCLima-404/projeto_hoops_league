from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware


from app.database import engine, Base


from app.models import models


from app.routes import auth_routes, jogo_routes, comp_routes


Base.metadata.create_all(bind=engine)


app = FastAPI(title="Hoops League API")


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    return {"message": "Hoops League API is running 🚀"}


app.include_router(auth_routes.router, prefix="/auth", tags=["Auth"])
app.include_router(jogo_routes.router, prefix="/jogos", tags=["Jogos"])
app.include_router(comp_routes.router, prefix="/competicoes", tags=["Competições"])