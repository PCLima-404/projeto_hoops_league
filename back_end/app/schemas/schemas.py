from pydantic import BaseModel, EmailStr, model_validator
from typing import Optional, List
from datetime import date, time

from app.models.models import (
    Posicao,
    StatusComp,
    Visibilidade,
    TipoCompeticao,
    ResultadoJogo
)



class UsuarioSchema(BaseModel):
    user: str
    nome: str
    idade: int
    email: EmailStr
    altura: float
    posicao_preferida: Optional[str] = "nao_sei"
    senha: str
    confirmar_senha: str

    @model_validator(mode='after')
    def verificar_senha(self):
        if self.senha != self.confirmar_senha:
            raise ValueError("As senhas não coincidem")
        return self

    class Config:
        from_attributes = True



class LoginSchema(BaseModel):
    email: EmailStr
    senha: str

    class Config:
        from_attributes = True


class UsuarioPublico(BaseModel):
    user: str
    nome: str
    idade: int
    altura: float
    pontos: int
    assistencias: int
    rebotes: int
    roubos: int
    bloqueios: int
    jogos: int
    overall: int
    posicao_preferida: Posicao

    class Config:
        from_attributes = True



class EditarUsuarioSchema(BaseModel):
    nome: Optional[str] = None
    idade: Optional[int] = None
    email: Optional[str] = None
    altura: Optional[float] = None
    posicao_preferida: Optional[str] = None
    senha: Optional[str] = None
    confirmar_senha: Optional[str] = None

    @model_validator(mode='after')
    def verificar_senha(self):
        if self.senha != self.confirmar_senha:
            raise ValueError("As senhas não coincidem")
        return self

    class Config:
        from_attributes = True


class CompeticaoCreate(BaseModel):
    local: str
    status: StatusComp = StatusComp.em_aberto
    visibilidade: Visibilidade
    qtd_times: int
    tipo: TipoCompeticao
    qtd_max_jogadores: int


    data_inscricoes: Optional[date] = None
    data_inicio: Optional[date] = None
    data_fim: Optional[date] = None


    data_partida: Optional[date] = None
    horario_partida: Optional[time] = None

    class Config:
        from_attributes = True



class JogadoresEstatisticas(BaseModel):
    fk_jogador_id: int
    fk_time_id: int
    pontos: int
    assistencias: int
    rebotes: int
    roubos: int
    bloqueios: int

    class Config:
        from_attributes = True


class CriarJogo(BaseModel):
    fk_competicao_id: int
    data: date
    horario: time

    class Config:
        from_attributes = True


class FinalizarJogo(BaseModel):
    pontuacao_1: int
    pontuacao_2: int
    resultado: ResultadoJogo
    estatisticas_jogadores: List[JogadoresEstatisticas]

    class Config:
        from_attributes = True