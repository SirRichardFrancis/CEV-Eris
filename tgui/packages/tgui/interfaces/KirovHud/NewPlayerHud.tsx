import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { Button, Stack, Box } from '../../components';
import { NewPlayerHudData } from './data';

export const NewPlayerHud = (props: any, context: any) => {
  const { act, data } = useBackend<NewPlayerHudData>(context);
  const { is_player_ready, is_round_started } = data;
  let join_button;
  if (is_round_started)
    join_button = (
      <Button
        icon={'users'}
        content={'Join'}
        onClick={() => {
          act('Join');
        }}
      />
    );
  else
    join_button = (
      <Button
        icon={is_player_ready ? 'toggle-on' : 'toggle-off'}
        content={is_player_ready ? 'Ready' : 'Not Ready'}
        color={is_player_ready ? 'good' : 'bad'}
        onClick={() => {
          act('Ready');
        }}
      />
    );

  return (
    <Window resizable canClose={0} canDrag={0} theme={'eris'}>
      <Window.Content>
        <Stack fill={true} align="center" vertical>
          <Stack.Item>
            <Button
              icon={'users'}
              content={'Setup Character'}
              onClick={() => {
                act('Setup');
              }}
            />
          </Stack.Item>
          <Stack.Item>{join_button}</Stack.Item>
          <Stack.Item>
            <Button
              icon={'ghost'}
              content={'Observe'}
              onClick={() => {
                act('Observe');
              }}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
