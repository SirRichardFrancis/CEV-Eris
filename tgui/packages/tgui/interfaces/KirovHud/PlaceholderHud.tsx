import { Window } from '../../layouts';

export const PlaceholderHud = (props: any, context: any) => {
  return (
    <Window resizable canClose={0} canDrag={0} theme={'eris'}>
      <Window.Content></Window.Content>
    </Window>
  );
};
