// 3d noise on object
// by imerso

in vec3 f_pos;

void main()
{
    float height = (1. + f_pos.y) * .5;
    vec3 color = mix(vec3(1., .5, .0), vec3(.0, 1., .5), height) * height;
    gl_FragColor = vec4(color, 1.);
}
