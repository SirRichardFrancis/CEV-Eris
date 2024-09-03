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

export enum MobType {
  Unknown = 'unknown',
  NewPlayer = 'new_player',
  Human = 'human',
}

export type MobHudData = {
  mob_type: string;
};

export type NewPlayerHudData = {
  is_player_ready: boolean;
  is_round_started: boolean;
  roundstart_timer: string;
  total_player_count: number;
  ready_player_count: number;
  crew_manifest: string[][];
};

export type CrewManifestReadyData = {
  game_state: number;
};

export type CrewManifestJoinData = {
  game_state: number;
};
