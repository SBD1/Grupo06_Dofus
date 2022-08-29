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
    figlet("DOFUS", async (_err, data) => {
      console.clear();
      console.log();
      console.log(gradient.pastel.multiline(data) + "\n");
      console.log(
        chalk.greenBright(
          String.raw`
       / \    )\__/(     / \       
      /   \  (_\  /_)   /   \      
 ____/_____\__\@  @/___/_____\____ 
|             |\../|              |
|              \VV/               |
|        ----JOGO MUD----         |
|____________________________ ____|
 |    /\ /      \\       \ /\    | 
 |  /   V        ))       V   \  | 
 |/     '       //       ´      \| 
 '              V               ´
       `.toString()
        )
      );
      const answer = await inquirer.prompt({
        name: "playOrListAchievements",
        type: "list",
        message: "Selecione uma opção.\n",
        choices: [Choices.PLAY_NOW, Choices.LIST_ACHIEVEMENTS, Choices.QUIT],
      });

      if (answer.playOrListAchievements === Choices.PLAY_NOW)
        await this.classScreen.handleClass();

      if (answer.playOrListAchievements === Choices.QUIT) return;

      if (answer.playOrListAchievements === Choices.LIST_ACHIEVEMENTS) return; // TODO

      while (true) {
        await this.gameScreen.handleGameScreen();
      }
    });
  }
}
