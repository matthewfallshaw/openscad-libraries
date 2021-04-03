function internal_chamfer(ext_chamfer,wall_thickness,angle=45) = (ext_chamfer*sin(angle)+2*wall_thickness*sin(angle)-2*wall_thickness)/sin(angle);
