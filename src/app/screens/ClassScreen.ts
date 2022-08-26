import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../connection/database.js";

export default class ClassScreen {
    private readonly idPersonagem: number

    constructor(idPersonagem: number){
        this.idPersonagem = idPersonagem
    }

  private async pickClass() {
    console.clear();
    console.log("Você ainda não tem uma classe");

    const availableClasses = await dbInstance`
        SELECT * FROM classe
        `;

        console.log(availableClasses)

    const answer = await inquirer.prompt({
      name: "pickClass",
      type: "list",
      message: "Por favor, selecione uma classe.\n",
      choices: [],
    });


  }

   async handleClass() {
    console.clear();

    const hasClass = await dbInstance`
        SELECT id_classe FROM personagens WHERE id = ${this.idPersonagem}
        `;

    console.log(hasClass[0])

    if (!hasClass[0]) {
      this.pickClass();
    }
  }
}
