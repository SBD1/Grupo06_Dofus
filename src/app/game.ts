import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";

import dbInstance from "./connection/database.js";
import { Choices } from "./util/constants.js";
import ClassScreen from "./screens/ClassScreen.js";
import GameScreen from "./screens/GameScreen.js";

export default class Game {
  private readonly classScreen;
  private readonly gameScreen;
  
  constructor() {
    this.classScreen = new ClassScreen(1);
    this.gameScreen = new GameScreen(1);

    this.run();
  }

  private async run() {
    figlet("DOFUS", "Doom", async (_err, data) => {
      console.clear();
      console.log(gradient.pastel.multiline(data) + "\n");

      const answer = await inquirer.prompt({
        name: "playOrListAchievements",
        type: "list",
        message: "Selecione uma opção.\n",
        choices: [Choices.PLAY_NOW, Choices.LIST_ACHIEVEMENTS, Choices.QUIT],
      });

      if (answer.playOrListAchievements === Choices.PLAY_NOW)
        await this.classScreen.handleClass();

        await this.gameScreen.handleGameScreen();

    });
  }
}
