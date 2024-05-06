obj0 = stlread('FusMesh.stl');

mplot1 = trimesh(obj0);
    mplot1.FaceColor = 'k';
    mplot1.EdgeColor = 'b';