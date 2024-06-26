import { Button, Section } from '../../components';
import { Window } from '../../layouts';

export const KirovHud = (props: any, context: any) => {
  return (
    <Window resizable>
      <Window.Content>
        <Section>
          <Button icon="power-off" selected={false} />
        </Section>
      </Window.Content>
    </Window>
  );
};
