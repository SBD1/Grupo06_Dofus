import chalk from "chalk";
import inquirer from "inquirer";
import dbInstance from "../connection/database.js";
import { Choices } from "../util/constants.js";
import { Item, TipoItem } from "../interfaces/item.js";

export default class InventoryScreen {
  private readonly idPersonagem;

  constructor(idPersonagem: number) {
    this.idPersonagem = idPersonagem;
  }

  public async handleInventoryScreen(): Promise<void> {
    console.clear();
    console.log();
    console.log();

    const answer = await inquirer.prompt({
      name: "inventoryScreen",
      type: "list",
      loop: false,
      pageSize: 5,
      message: "Selecione uma opção.\n",
      choices: [
        Choices.LIST_ITEMS,
        Choices.LIST_WEAPONS,
        Choices.LIST_ARMOR,
        Choices.LIST_AMULETS,
        Choices.RETURN,
      ],
    });

    if (answer.inventoryScreen === Choices.RETURN) return;

    const items: Item[] = await dbInstance`
      SELECT I.id, I.nome, I.tipo_item, I.descricao, I.valor_moedas, A.dano, B.vida, C.sorte, count(I.id) as qnt FROM item I
      INNER JOIN instancia_item J ON I.id = J.id_item
      INNER JOIN mochila M ON M.id_instancia_item = J.id
      INNER JOIN personagens P ON p.id = M.id_personagem
      LEFT JOIN arma A ON A.id_item = I.id
      LEFT JOIN armadura B ON B.id_item = i.id
      LEFT JOIN amuleto C ON C.id_item = I.id
      WHERE P.id = ${this.idPersonagem}
      GROUP BY I.id, A.dano, B.vida, C.sorte
    `;

    await this.listItems(answer.inventoryScreen, items);
  }

  private async listItems(choice: string, items: Item[]) {
    console.clear();
    console.log();
    console.log();

    const mapItemType: any = {};
    mapItemType[Choices.LIST_AMULETS] = TipoItem.AMULETO;
    mapItemType[Choices.LIST_WEAPONS] = TipoItem.ARMA;
    mapItemType[Choices.LIST_ARMOR] = TipoItem.ARMADURA;
    mapItemType[Choices.LIST_ITEMS] = TipoItem.NAO_EQUIPAVEL;

    console.log("Selecione o item para ver mais informações");

    const filteredItems: any = {};

    items.forEach((item) => {
      if (item.tipo_item === mapItemType[choice]) {
        const key = `${item.nome}  Quantidade: ${item.qnt}`;

        filteredItems[key] = item;
      }
    });

    const answer = await inquirer.prompt({
      name: "listItemsScreen",
      type: "list",
      loop: false,
      pageSize: 5,
      message: "Selecione uma opção.\n",
      choices: [...Object.keys(filteredItems), Choices.RETURN],
    });

    if (answer.listItemsScreen === Choices.RETURN) return;

    await this.showItemDetails(filteredItems[answer.listItemsScreen]);
  }

  private async showItemDetails(item: Item) {
    const itemAttributes: any = {};
    itemAttributes[TipoItem.AMULETO] = `Sorte:   ${item?.sorte}`;
    itemAttributes[TipoItem.ARMA] = `Dano   ${item?.dano}`;
    itemAttributes[TipoItem.ARMADURA] = `Vida   ${item?.vida}`;
    itemAttributes[TipoItem.NAO_EQUIPAVEL] = null;

    console.clear();
    console.log();
    console.log();

    console.log(chalk.cyanBright(item.nome));
    console.log(`Quantidade : ${item.qnt}`);
    console.log();
    console.log(item.descricao);
    console.log();
    console.log(itemAttributes[item.tipo_item]);
    console.log();

    const equip: string[] = [];
    if (item.tipo_item !== TipoItem.NAO_EQUIPAVEL) equip.push(Choices.EQUIP);

    const answer = await inquirer.prompt({
      name: "itemDetailsScreen",
      type: "list",
      loop: false,
      pageSize: 5,
      message: "Selecione uma opção.\n",
      choices: [...equip, Choices.RETURN],
    });

    if (answer.itemDetailsScreen === Choices.RETURN) return;

    await this.equipItem(item);
  }

  private async equipItem(item: Item) {
    const equipItem: any = {};
    equipItem[
      TipoItem.ARMADURA
    ] = `START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    DO
    $$
      DECLARE
      id_instancia_armadura_nova INTEGER;
      id_instancia_armadura_antiga INTEGER;
      id_item_mochila INTEGER;
      BEGIN
  
      SELECT id_armadura INTO id_instancia_armadura_antiga
        FROM personagens WHERE id = ${this.idPersonagem};
  
          --- SELECIONA O ID DA INSTANCIA DA ARMADURA
          SELECT I.id, M.id INTO id_instancia_armadura_nova, id_item_mochila
            FROM instancia_item I 
            JOIN mochila M on I.id = M.id_instancia_item 
            JOIN 	item J on I.id_item = J.id
            WHERE I.id_item = ${item.id} 
            AND M.id_personagem = ${this.idPersonagem}
            AND J.tipo_item = 'armadura'
          LIMIT 1;
  
        --- DELETA A INSTANCIA DE ARMADURA DA MOCHILA
          DELETE FROM mochila WHERE id = id_item_mochila;
  
        --- EQUIPA A INSTANCIA DA ARMADURA NO PERSONAGEM
          UPDATE personagens SET id_armadura = id_instancia_armadura_nova  WHERE id = ${this.idPersonagem};
  
      --- SE JA POSSUIR ARMADURA, RETIRA A ARMADURA ANTIGA E COLOCA NA MOCHILA
      IF (id_instancia_armadura_antiga IS NOT NULL) THEN
        UPDATE personagens SET id_armadura = NULL  WHERE id = 1;
        INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (${this.idPersonagem}, id_instancia_armadura_antiga);
      END IF;
  
      END;  
    $$;
  COMMIT;`;
    equipItem[TipoItem.AMULETO] = `
START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  DO
  $$
    DECLARE
      id_instancia_amuleto_nova INTEGER;
	    id_instancia_amuleto_antiga INTEGER;
      id_item_mochila INTEGER;
    BEGIN

		SELECT id_amuleto INTO id_instancia_amuleto_antiga
			FROM personagens WHERE id = ${this.idPersonagem};

    --- SELECIONA O ID DA INSTANCIA DO AMULETO
        SELECT I.id, M.id INTO id_instancia_amuleto_nova, id_item_mochila
          FROM instancia_item I 
          JOIN mochila M on I.id = M.id_instancia_item 
          JOIN 	item J on I.id_item = J.id
          WHERE I.id_item = ${item.id}
          AND M.id_personagem = ${this.idPersonagem}
          AND J.tipo_item = 'amuleto'
        LIMIT 1;

      --- DELETA A INSTANCIA DE AMULETO DA MOCHILA
      DELETE FROM mochila WHERE id = id_item_mochila;

      --- EQUIPA A INSTANCIA DA AMULETO NO PERSONAGEM
        UPDATE personagens SET id_amuleto = id_instancia_amuleto_nova  WHERE id = ${this.idPersonagem};

		--- SE JA POSSUIR AMULETO, RETIRA O AMULETO ANTIGO E COLOCA NA MOCHILA
		IF (id_instancia_amuleto_antiga IS NOT NULL) THEN
			UPDATE personagens SET id_amuleto = NULL  WHERE id = ${this.idPersonagem};
			INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (${this.idPersonagem}, id_instancia_amuleto_antiga);
		END IF;

    
    END;  
  $$;
COMMIT;

`;
    equipItem[TipoItem.ARMA] = `
START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
DO
$$
  DECLARE
    id_instancia_arma_nova INTEGER;
    id_instancia_arma_antiga INTEGER;
    id_item_mochila INTEGER;
  BEGIN

  SELECT id_arma INTO id_instancia_arma_antiga
    FROM personagens WHERE id = ${this.idPersonagem};

      --- SELECIONA O ID DA INSTANCIA DO ARMA
      SELECT I.id, M.id INTO id_instancia_arma_nova, id_item_mochila
        FROM instancia_item I 
        JOIN mochila M on I.id = M.id_instancia_item 
        JOIN 	item J on I.id_item = J.id
        WHERE I.id_item = ${item.id}
        AND M.id_personagem = ${this.idPersonagem}
        AND J.tipo_item = 'arma'
      LIMIT 1;

    --- DELETA A INSTANCIA DE ARMA DA MOCHILA
    DELETE FROM mochila WHERE id = id_item_mochila;

    --- EQUIPA A INSTANCIA DA ARMA NO PERSONAGEM
      UPDATE personagens SET id_arma = id_instancia_arma_nova  WHERE id = ${this.idPersonagem};

  --- SE JA POSSUIR ARMA, RETIRA A ARMA ANTIGA E COLOCA NA MOCHILA
  IF (id_instancia_arma_antiga IS NOT NULL) THEN
    UPDATE personagens SET id_arma = NULL  WHERE id = ${this.idPersonagem};
    INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (${this.idPersonagem}, id_instancia_arma_antiga);
  END IF;

  END;  
$$;
COMMIT;
`;

    await dbInstance.unsafe(equipItem[item.tipo_item]);
  }
}
