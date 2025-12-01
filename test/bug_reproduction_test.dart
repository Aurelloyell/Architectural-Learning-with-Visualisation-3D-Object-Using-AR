import 'package:flutter_test/flutter_test.dart';
import 'package:arsitektur_app/screens/ar_page.dart';

void main() {
  test('formatAssetName correctly formats file names', () {
    // Normal cases
    expect(ArPage.formatAssetName('assets/3d/astronaut.glb'), 'Astronaut');
    expect(ArPage.formatAssetName('assets/3d/my_model.glb'), 'My Model');

    // Bug reproduction: Uppercase extensions
    // Current buggy behavior: 'Model.GLB' -> 'Model.GLB' (because replaceAll is case sensitive)
    // Desired behavior: 'Model.GLB' -> 'Model'

    // This expectation asserts the DESIRED behavior. It should fail now.
    expect(ArPage.formatAssetName('assets/3d/Model.GLB'), 'Model', reason: 'Should handle uppercase GLB extension');
    expect(ArPage.formatAssetName('assets/3d/Another.Gltf'), 'Another', reason: 'Should handle mixed case Gltf extension');
  });
}
