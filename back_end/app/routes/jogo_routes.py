from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.dependencies import get_db, verificar_token
from app.schemas.schemas import CriarJogo, FinalizarJogo
from app.models.models import (
    Jogo,
    Competicao,
    Time_Jogo,
    Jogador,
    ResultadoTimeJogo,
    ResultadoJogo
)

router = APIRouter(prefix="/jogos", tags=["jogos"])


# =========================
# CRIAR JOGO
# =========================
@router.post("/criar")
async def criar_jogo(
    dados: CriarJogo,
    session: Session = Depends(get_db),
    usuario_logado: Jogador = Depends(verificar_token)
):
    competicao = session.query(Competicao).filter(
        Competicao.id == dados.fk_Competicao_id
    ).first()

    if not competicao:
        raise HTTPException(status_code=404, detail="Competição não encontrada")

    if competicao.fk_Jogador_id != usuario_logado.id:
        raise HTTPException(
            status_code=403,
            detail="Sem permissão para criar jogo"
        )

    novo_jogo = Jogo(
        fk_Competicao_id=dados.fk_Competicao_id,
        data=dados.data,
        horario=dados.horario
    )

    try:
        session.add(novo_jogo)
        session.commit()
        session.refresh(novo_jogo)

        return {
            "id": novo_jogo.id,
            "data": str(novo_jogo.data),
            "horario": novo_jogo.horario
        }

    except Exception as e:
        session.rollback()
        raise HTTPException(
            status_code=500,
            detail=f"Erro ao criar jogo: {str(e)}"
        )


# =========================
# LISTAR JOGOS (FORMATADO PRO FRONT)
# =========================
@router.get("/")
async def listar_jogos(
    session: Session = Depends(get_db),
    usuario: Jogador = Depends(verificar_token)
):
    jogos = session.query(Jogo).all()

    resultado = []
    for j in jogos:
        resultado.append({
            "id": j.id,
            "data": str(j.data),
            "horario": j.horario,
            "pontuacao_1": j.pontuacao_1,
            "pontuacao_2": j.pontuacao_2,
            "resultado": j.resultado
        })

    return resultado


# =========================
# BUSCAR JOGO
# =========================
@router.get("/{jogo_id}")
async def buscar_jogo(
    jogo_id: int,
    session: Session = Depends(get_db),
    usuario: Jogador = Depends(verificar_token)
):
    jogo = session.query(Jogo).filter(Jogo.id == jogo_id).first()

    if not jogo:
        raise HTTPException(status_code=404, detail="Jogo não encontrado")

    return {
        "id": jogo.id,
        "data": str(jogo.data),
        "horario": jogo.horario,
        "pontuacao_1": jogo.pontuacao_1,
        "pontuacao_2": jogo.pontuacao_2,
        "resultado": jogo.resultado
    }


# =========================
# FINALIZAR JOGO
# =========================
@router.post("/{jogo_id}/finalizar")
async def finalizar_jogo_completo(
    jogo_id: int,
    dados: FinalizarJogo,
    session: Session = Depends(get_db),
    usuario_logado: Jogador = Depends(verificar_token)
):
    jogo = session.query(Jogo).filter(Jogo.id == jogo_id).first()

    if not jogo:
        raise HTTPException(status_code=404, detail="Jogo não encontrado")

    try:
        # Atualiza placar
        jogo.pontuacao_1 = dados.pontuacao_1
        jogo.pontuacao_2 = dados.pontuacao_2
        jogo.resultado = dados.resultado_geral

        # ================= TIMES =================
        res_t1 = (
            ResultadoTimeJogo.vitoria
            if dados.resultado_geral == ResultadoJogo.time_1
            else ResultadoTimeJogo.derrota
        )

        res_t2 = (
            ResultadoTimeJogo.vitoria
            if dados.resultado_geral == ResultadoJogo.time_2
            else ResultadoTimeJogo.derrota
        )

        time1 = Time_Jogo(
            fk_Time_id=dados.id_time_1,
            fk_Jogo_id=jogo_id,
            resultado=res_t1,
            pontuacao_total=dados.pontuacao_1
        )

        time2 = Time_Jogo(
            fk_Time_id=dados.id_time_2,
            fk_Jogo_id=jogo_id,
            resultado=res_t2,
            pontuacao_total=dados.pontuacao_2
        )

        session.add_all([time1, time2])

        # ================= ESTATÍSTICAS =================
        for est in dados.estatisticas_jogadores:

            nova_est = Estatistica(
                fk_Jogador_id=est.jogador_id,
                fk_Jogo_id=jogo_id,
                fk_Time_id=est.time_id,
                roubos=est.roubos,
                rebotes=est.rebotes,
                assistencias=est.assistencias,
                bloqueios=est.bloqueios,
                pontos=est.pontos
            )
            session.add(nova_est)

            atleta = session.query(Jogador).filter(
                Jogador.id == est.jogador_id
            ).first()

            if atleta:
                atleta.pontos += est.pontos
                atleta.assistencias += est.assistencias
                atleta.rebotes += est.rebotes
                atleta.roubos += est.roubos
                atleta.bloqueios += est.bloqueios
                atleta.jogos += 1

                soma = (
                    atleta.pontos +
                    atleta.assistencias +
                    atleta.rebotes +
                    atleta.roubos +
                    atleta.bloqueios
                )

                atleta.overall = int(
                    soma / (atleta.jogos * 5)
                ) if atleta.jogos > 0 else 0

        session.commit()

        return {"mensagem": "Jogo finalizado com sucesso"}

    except Exception as e:
        session.rollback()
        raise HTTPException(
            status_code=500,
            detail=f"Erro ao finalizar jogo: {str(e)}"
        )