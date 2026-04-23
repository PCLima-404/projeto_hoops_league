from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from fastapi.security import OAuth2PasswordRequestForm
from jose import jwt
from datetime import datetime, timedelta, timezone

from app.config import bcrypt_context, ALGORITHM, SECRET_KEY, ACCESS_TOKEN_EXPIRE_MINUTES
from app.dependencies import get_db, verificar_token
from app.models.models import Jogador
from app.schemas.schemas import UsuarioSchema, LoginSchema, UsuarioPublico, EditarUsuarioSchema

router = APIRouter(tags=["Auth"])


# =========================
# FUNÇÕES AUXILIARES
# =========================
def autenticar_usuario(email: str, senha: str, db: Session):
    usuario = db.query(Jogador).filter(Jogador.email == email).first()

    if not usuario:
        return None

    if not bcrypt_context.verify(senha, usuario.senha):
        return None

    return usuario


def criar_token(user_id: int, duracao: timedelta = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)):
    exp = datetime.now(timezone.utc) + duracao

    payload = {
        "sub": str(user_id),
        "exp": exp
    }

    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


# =========================
# ROOT
# =========================
@router.get("/")
def auth_root():
    return {"message": "Auth funcionando 🚀"}


# =========================
# REGISTER
# =========================
@router.post("/register")
def criar_conta(usuario: UsuarioSchema, db: Session = Depends(get_db)):
    existe = db.query(Jogador).filter(Jogador.email == usuario.email).first()

    if existe:
        raise HTTPException(status_code=400, detail="Email já cadastrado")

    senha_hash = bcrypt_context.hash(usuario.senha)

    novo = Jogador(
        user=usuario.user,
        nome=usuario.nome,
        idade=usuario.idade,
        email=usuario.email,
        altura=usuario.altura,
        posicao_preferida=usuario.posicao_preferida,
        senha=senha_hash,
        pontos=0,
        assistencias=0,
        rebotes=0,
        roubos=0,
        bloqueios=0,
        ativo=True,
        jogos=0,
        overall=0
    )

    try:
        db.add(novo)
        db.commit()
        db.refresh(novo)
        return {"message": "Usuário criado com sucesso"}
    except Exception as e: 
        db.rollback()
        print(f"ERRO REAL NO BACKEND: {str(e)}") 
        raise HTTPException(status_code=500, detail=str(e))


# =========================
# LOGIN (USADO NO FLUTTER)
# =========================
@router.post("/login")
def login(dados: LoginSchema, db: Session = Depends(get_db)):
    usuario = autenticar_usuario(dados.email, dados.senha, db)

    if not usuario:
        raise HTTPException(status_code=401, detail="Credenciais inválidas")

    access_token = criar_token(usuario.id)

    return {
        "access_token": access_token,
        "token_type": "Bearer"
    }


# =========================
# PROFILE (ESSENCIAL PRO APP)
# =========================
@router.get("/me", response_model=UsuarioPublico)
def get_me(usuario: Jogador = Depends(verificar_token)):
    return usuario


# =========================
# BUSCAR USUÁRIO
# =========================
@router.get("/buscar-usuario/{user}", response_model=list[UsuarioPublico])
def buscar_jogador(
    user: str,
    db: Session = Depends(get_db),
    usuario: Jogador = Depends(verificar_token)
):
    if not usuario.ativo:
        raise HTTPException(status_code=400, detail="Usuário inválido")

    usuarios = db.query(Jogador).filter(
        Jogador.user.ilike(f"%{user}%")
    ).all()

    return usuarios


# =========================
# UPDATE PROFILE (USADO NA POSITION PAGE)
# =========================
@router.put("/editar-me")
def editar_usuario(
    dados: EditarUsuarioSchema,
    db: Session = Depends(get_db),
    usuario: Jogador = Depends(verificar_token)
):
    if not usuario.ativo:
        raise HTTPException(status_code=403, detail="Usuário inativo")

    # 🔥 atualiza só o que vier
    if dados.nome is not None:
        usuario.nome = dados.nome

    if dados.idade is not None:
        usuario.idade = dados.idade

    if dados.email is not None:
        usuario.email = dados.email

    if dados.altura is not None:
        usuario.altura = dados.altura

    if dados.posicao_preferida is not None:
        usuario.posicao_preferida = dados.posicao_preferida

    if dados.senha:
        usuario.senha = bcrypt_context.hash(dados.senha)

    try:
        db.commit()
        db.refresh(usuario)
        return {"message": "Perfil atualizado com sucesso"}
    except Exception:
        db.rollback()
        raise HTTPException(status_code=500, detail="Erro ao atualizar")


# =========================
# DELETE (DESATIVAR)
# =========================
@router.delete("/deletar-usuario")
def deletar_usuario(
    db: Session = Depends(get_db),
    usuario: Jogador = Depends(verificar_token)
):
    usuario.ativo = False

    try:
        db.commit()
        return {"message": "Usuário desativado"}
    except Exception:
        db.rollback()
        raise HTTPException(status_code=500, detail="Erro ao deletar")


# =========================
# REFRESH TOKEN
# =========================
@router.get("/refresh")
def refresh(usuario: Jogador = Depends(verificar_token)):
    if not usuario.ativo:
        raise HTTPException(status_code=403, detail="Usuário inativo")

    novo_token = criar_token(usuario.id)

    return {
        "access_token": novo_token,
        "token_type": "Bearer"
    }