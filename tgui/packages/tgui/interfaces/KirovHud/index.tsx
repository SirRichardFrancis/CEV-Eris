import { useBackend } from '../../backend';
import { NewPlayerHud } from './NewPlayerHud';
import { NewPlayerHudData } from './data';

export const KirovHud = (props: any, context: any) => {
  const { act, data } = useBackend<NewPlayerHudData>(context);
  return <NewPlayerHud />;
};

/*
export const KirovHud = (props, context) => {
  const { data } = useBackend<PreferencesMenuData>(context);

  const window = data.window;

  switch (window) {
    case Window.Character:
      return <CharacterPreferenceWindow />;
    case Window.Game:
      return <GamePreferenceWindow />;
    case Window.Keybindings:
      return (
        <GamePreferenceWindow
          startingPage={GamePreferencesSelectedPage.Keybindings}
        />
      );
    default:
      exhaustiveCheck(window);
  }
};
*/
