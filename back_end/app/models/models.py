from datetime import date, time
from typing import List, Optional
from enum import Enum as PyEnum

from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, ForeignKey, Enum, Boolean
from sqlalchemy.dialects.mysql import INTEGER, TINYINT, SMALLINT, DECIMAL

from app.database import Base



class Posicao(PyEnum):
    armador = 'armador'
    ala_armador = 'ala_armador'
    ala = 'ala'
    ala_pivo = 'ala_pivo'
    pivo = 'pivo'
    nao_sei = 'nao_sei'


class StatusComp(PyEnum):
    em_aberto = 'em_aberto'
    cancelado = 'cancelado'
    confirmado = 'confirmado'
    encerrado = 'encerrado'


class Visibilidade(PyEnum):
    publico = 'publico'
    privado = 'privado'


class TipoCompeticao(PyEnum):
    torneio = 'torneio'
    partida = 'partida'


class ResultadoJogo(PyEnum):
    time_1 = 'time_1'
    time_2 = 'time_2'


class ResultadoTimeJogo(PyEnum):
    vitoria = 'vitoria'
    derrota = 'derrota'
    empate = 'empate'


class RespostaParticipacao(PyEnum):
    confirmado = 'confirmado'
    recusado = 'recusado'
    esperando_retorno = 'esperando_retorno'



class Jogador(Base):
    __tablename__ = "jogador"

    id: Mapped[int] = mapped_column(INTEGER(unsigned=True), primary_key=True, autoincrement=True)
    user: Mapped[str] = mapped_column(String(100), unique=True)
    nome: Mapped[str] = mapped_column(String(250))
    idade: Mapped[int] = mapped_column(TINYINT(unsigned=True))
    email: Mapped[str] = mapped_column(String(200))
    altura: Mapped[float] = mapped_column(DECIMAL(4,2))
    pontos: Mapped[int] = mapped_column(SMALLINT(unsigned=True))
    assistencias: Mapped[int] = mapped_column(SMALLINT(unsigned=True))
    rebotes: Mapped[int] = mapped_column(SMALLINT(unsigned=True))
    roubos: Mapped[int] = mapped_column(SMALLINT(unsigned=True))
    bloqueios: Mapped[int] = mapped_column(SMALLINT(unsigned=True))
    ativo: Mapped[bool] = mapped_column(Boolean, default=True)
    jogos: Mapped[int] = mapped_column(SMALLINT(unsigned=True))
    overall: Mapped[int] = mapped_column(TINYINT(unsigned=True))
    posicao_preferida: Mapped[Posicao] = mapped_column(Enum(Posicao))
    senha: Mapped[str] = mapped_column(String(512))

    competicoes_criadas: Mapped[List["Competicao"]] = relationship(back_populates="criador")


class Time(Base):
    __tablename__ = "time"

    id: Mapped[int] = mapped_column(INTEGER(unsigned=True), primary_key=True, autoincrement=True)
    nome: Mapped[str] = mapped_column(String(150))


class Competicao(Base):
    __tablename__ = "competicao"

    id: Mapped[int] = mapped_column(INTEGER(unsigned=True), primary_key=True)
    local: Mapped[str] = mapped_column(String(300))
    status: Mapped[StatusComp] = mapped_column(Enum(StatusComp))
    visibilidade: Mapped[Visibilidade] = mapped_column(Enum(Visibilidade))
    qtd_times: Mapped[int] = mapped_column(TINYINT(unsigned=True))
    tipo: Mapped[TipoCompeticao] = mapped_column(Enum(TipoCompeticao))
    fk_jogador_id: Mapped[int] = mapped_column(
        INTEGER(unsigned=True),
        ForeignKey("jogador.id")
    )
    qtd_max_jogadores: Mapped[int] = mapped_column(TINYINT(unsigned=True))

    criador: Mapped["Jogador"] = relationship(back_populates="competicoes_criadas")


class Jogo(Base):
    __tablename__ = "jogo"

    id: Mapped[int] = mapped_column(INTEGER(unsigned=True), primary_key=True)
    resultado: Mapped[Optional[ResultadoJogo]] = mapped_column(Enum(ResultadoJogo))
    pontuacao_1: Mapped[int] = mapped_column(TINYINT(unsigned=True))
    pontuacao_2: Mapped[int] = mapped_column(TINYINT(unsigned=True))
    fk_competicao_id: Mapped[int] = mapped_column(
        INTEGER(unsigned=True),
        ForeignKey("competicao.id")
    )
    data: Mapped[date]
    horario: Mapped[time]


class Time_Jogo(Base):
    __tablename__ = "time_jogo"

    fk_time_id: Mapped[int] = mapped_column(
        INTEGER(unsigned=True),
        ForeignKey("time.id"),
        primary_key=True
    )
    fk_jogo_id: Mapped[int] = mapped_column(
        INTEGER(unsigned=True),
        ForeignKey("jogo.id"),
        primary_key=True
    )
    resultado: Mapped[Optional[ResultadoTimeJogo]] = mapped_column(Enum(ResultadoTimeJogo))

class Participacao(Base):
    __tablename__ = "participacao"

    fk_jogador_id: Mapped[int] = mapped_column(
        INTEGER(unsigned=True),
        ForeignKey("jogador.id"),
        primary_key=True
    )
    fk_competicao_id: Mapped[int] = mapped_column(
        INTEGER(unsigned=True),
        ForeignKey("competicao.id"),
        primary_key=True
    )
    resposta: Mapped[Optional[RespostaParticipacao]] = mapped_column(Enum(RespostaParticipacao))

class Torneio(Base):
    __tablename__ = "torneio"

    id: Mapped[int] = mapped_column(INTEGER(unsigned=True), primary_key=True, autoincrement=True)
    fk_Competicao_id: Mapped[int] = mapped_column(
        INTEGER(unsigned=True), 
        ForeignKey("competicao.id")
    )
    data_inscricoes: Mapped[Optional[date]]
    data_inicio: Mapped[date]
    data_fim: Mapped[date]


class Partida(Base):
    __tablename__ = "partida"

    id: Mapped[int] = mapped_column(INTEGER(unsigned=True), primary_key=True, autoincrement=True)
    fk_Competicao_id: Mapped[int] = mapped_column(
        INTEGER(unsigned=True), 
        ForeignKey("competicao.id")
    )
    data: Mapped[date]
    horario: Mapped[time]