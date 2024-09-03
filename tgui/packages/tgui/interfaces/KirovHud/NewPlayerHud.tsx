import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { Button, Stack, LabeledList, Section } from '../../components';
import { NewPlayerHudData } from './data';

export const NewPlayerHud = (props: any, context: any) => {
  const { act, data } = useBackend<NewPlayerHudData>(context);
  const {
    is_player_ready,
    is_round_started,
    roundstart_timer,
    crew_manifest,
    ready_player_count,
    total_player_count,
  } = data;
  let default_join_button;
  if (is_round_started)
    default_join_button = (
      <Button
        icon={'users'}
        content={'Join'}
        onClick={() => {
          act('Join');
        }}
      />
    );
  else
    default_join_button = (
      <Button
        icon={is_player_ready ? 'toggle-on' : 'toggle-off'}
        content={is_player_ready ? 'Ready' : 'Not Ready'}
        color={is_player_ready ? 'good' : 'bad'}
        onClick={() => {
          act('Ready');
        }}
      />
    );

  let crew_manifest_elements: Element[] = [];
  let players_ready_count;
  if (!is_round_started) {
    let ready_string: string =
      'Players ready:   ' + ready_player_count + ' / ' + total_player_count;
    players_ready_count = (
      <Section title={ready_string}>Time To Start: {roundstart_timer}</Section>
    );
  }
  var current_department: string = 'Bug Writing Department';
  var avoid_duplicate_of_rank: string = 'Bluespace Technician';
  for (let manifest_entry of crew_manifest) {
    let player_rank: string = manifest_entry['rank'];
    if (player_rank == avoid_duplicate_of_rank) {
      continue;
    } else {
      avoid_duplicate_of_rank == '';
    }
    let player_department: string = manifest_entry['department'];
    let player_name: string = manifest_entry['name'];
    if (player_department != current_department) {
      current_department = manifest_entry['department'];
      crew_manifest_elements.push(
        <LabeledList.Item label="">{current_department}</LabeledList.Item>,
      );
    }

    if (player_name) {
      crew_manifest_elements.push(
        <LabeledList.Item label={player_rank}>{player_name}</LabeledList.Item>,
      );
    } else {
      avoid_duplicate_of_rank = player_rank;
      let join_as_string: string = 'Join as ';
      join_as_string += player_rank;
      crew_manifest_elements.push(
        <LabeledList.Item>
          <Button
            content={join_as_string}
            onClick={() => {
              act('Join_as', { player_rank });
            }}
          ></Button>
        </LabeledList.Item>,
      );
    }
  }

  return (
    <Window resizable canClose={0} canDrag={0} theme={'eris'}>
      <Window.Content>
        <Stack fill={false} align="center" vertical>
          <Stack.Item>
            <Button
              icon={'users'}
              content={'Setup Character'}
              onClick={() => {
                act('Setup');
              }}
            />
          </Stack.Item>
          <Stack.Item>{default_join_button}</Stack.Item>
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
        <Stack.Item>{players_ready_count}</Stack.Item>
        <Stack.Item>
          <LabeledList>{crew_manifest_elements}</LabeledList>
        </Stack.Item>
      </Window.Content>
    </Window>
  );
};
