export enum Window {
  NewPlayerHud = 0,
  ObserverHud = 1,
  HumanHud = 2,
}

export enum GameState {
  GameStateStartup = 0,
  GameStatePregame = 1,
  GameStateSettingUp = 2,
  GameStatePlaying = 3,
  GameStateFinished = 4,
}

export type NewPlayerHudData = {
  game_state: number;
  is_player_ready: boolean;
  is_round_started: boolean;
};

export type CrewManifestReadyData = {
  game_state: number;
};

export type CrewManifestJoinData = {
  game_state: number;
};
