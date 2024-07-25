import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { Button, Stack, Box } from '../../components';
import { CrewManifestReadyData } from './data';

export const CrewManifestReady = (props: any, context: any) => {
  const { act, data } = useBackend<CrewManifestReadyData>(context);
  const { game_state } = data;
  return (
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
  );
};
