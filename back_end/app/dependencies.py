from fastapi import Depends, HTTPException
from sqlalchemy.orm import Session
from jose import jwt, JWTError

from app.database import SessionLocal
from app.models.models import Jogador
from app.config import SECRET_KEY, ALGORITHM, oauth2_schema



def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()



def verificar_token(
    token: str = Depends(oauth2_schema),
    db: Session = Depends(get_db)
):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id = payload.get("sub")

        if user_id is None:
            raise HTTPException(status_code=401, detail="Token inválido")

    except JWTError:
        raise HTTPException(status_code=401, detail="Acesso negado")

    usuario = db.query(Jogador).filter(Jogador.id == user_id).first()

    if not usuario:
        raise HTTPException(status_code=401, detail="Usuário não encontrado")

    return usuario