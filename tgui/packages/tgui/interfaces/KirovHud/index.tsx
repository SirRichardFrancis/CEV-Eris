import { useBackend } from '../../backend';
import { NewPlayerHud } from './NewPlayerHud';
import { HumanHud } from './HumanHud';
import { PlaceholderHud } from './PlaceholderHud';
import { MobHudData, MobType } from './data';

export const KirovHud = (props: any, context: any) => {
  const { act, data } = useBackend<MobHudData>(context);
  const { mob_type } = data;

  switch (mob_type) {
    case MobType.NewPlayer:
      return <NewPlayerHud />;
    case MobType.Human:
      return <HumanHud />;
    default:
      return <PlaceholderHud />;
  }
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
