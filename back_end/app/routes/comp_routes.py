from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.dependencies import get_db, verificar_token
from app.models.models import Jogador, Competicao, TipoCompeticao, Torneio, Partida, StatusComp
from app.schemas.schemas import CompeticaoCreate


router = APIRouter(
    prefix="/competicoes",
    tags=["Competições"],
    dependencies=[Depends(verificar_token)]
)



@router.post("/criar")
def criar_competicao(
    dados: CompeticaoCreate,
    db: Session = Depends(get_db),
    usuario: Jogador = Depends(verificar_token)
):
    nova_comp = Competicao(
        local=dados.local,
        status=dados.status,
        visibilidade=dados.visibilidade,
        qtd_times=dados.qtd_times,
        tipo=dados.tipo,
        fk_jogador_id=usuario.id,
        qtd_max_jogadores=dados.qtd_max_jogadores
    )

    try:
        db.add(nova_comp)
        db.flush()

       
        if dados.tipo == TipoCompeticao.torneio:
            if not dados.data_inicio or not dados.data_fim:
                raise HTTPException(status_code=400, detail="Torneio precisa de datas")

            torneio = Torneio(
                fk_Competicao_id=nova_comp.id,
                data_inscricoes=dados.data_inscricoes,
                data_inicio=dados.data_inicio,
                data_fim=dados.data_fim
            )
            db.add(torneio)

     
        elif dados.tipo == TipoCompeticao.partida:
            if not dados.data_partida or not dados.horario_partida:
                raise HTTPException(status_code=400, detail="Partida precisa de data e horário")

            partida = Partida(
                fk_Competicao_id=nova_comp.id,
                data=dados.data_partida,
                horario=dados.horario_partida
            )
            db.add(partida)

        db.commit()
        return {"message": "Competição criada com sucesso", "id": nova_comp.id}

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Erro ao criar: {str(e)}")



@router.get("/")
def listar_competicoes(db: Session = Depends(get_db)):
    return db.query(Competicao).all()



@router.put("/atualizar/{comp_id}")
def atualizar_competicao(
    comp_id: int,
    dados: CompeticaoCreate,
    db: Session = Depends(get_db),
    usuario: Jogador = Depends(verificar_token)
):
    comp = db.get(Competicao, comp_id)

    if not comp:
        raise HTTPException(status_code=404, detail="Competição não encontrada")

    if comp.fk_jogador_id != usuario.id:
        raise HTTPException(status_code=403, detail="Sem permissão")

    try:
        comp.local = dados.local
        comp.status = dados.status
        comp.visibilidade = dados.visibilidade
        comp.qtd_times = dados.qtd_times
        comp.qtd_max_jogadores = dados.qtd_max_jogadores

     
        if comp.tipo == TipoCompeticao.torneio:
            torneio = db.query(Torneio).filter_by(fk_Competicao_id=comp.id).first()
            if torneio:
                torneio.data_inscricoes = dados.data_inscricoes
                torneio.data_inicio = dados.data_inicio
                torneio.data_fim = dados.data_fim

 
        elif comp.tipo == TipoCompeticao.partida:
            partida = db.query(Partida).filter_by(fk_Competicao_id=comp.id).first()
            if partida:
                partida.data = dados.data_partida
                partida.horario = dados.horario_partida

        db.commit()
        return {"message": "Competição atualizada com sucesso"}

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Erro ao atualizar: {str(e)}")



@router.delete("/deletar/{comp_id}")
def deletar_competicao(
    comp_id: int,
    db: Session = Depends(get_db),
    usuario: Jogador = Depends(verificar_token)
):
    comp = db.get(Competicao, comp_id)

    if not comp:
        raise HTTPException(status_code=404, detail="Competição não encontrada")

    if comp.fk_jogador_id != usuario.id:
        raise HTTPException(status_code=403, detail="Permissão negada")

    if comp.status == StatusComp.encerrado:
        raise HTTPException(
            status_code=400,
            detail="Não é possível deletar competição encerrada"
        )

    try:
        db.delete(comp)
        db.commit()
        return {"message": "Competição deletada com sucesso"}

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Erro ao deletar: {str(e)}")