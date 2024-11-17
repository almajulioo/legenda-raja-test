shader_type canvas_item;

uniform int h_frames = 10;
uniform int v_frames = 1;
uniform float speed = 10.0;

void fragment() {
   
    // Calculate the total number of frames
    int total_frames = h_frames * v_frames;

    // Determine the current frame based on time and speed
    int current_frame = int(TIME * speed) % total_frames;

    // Calculate frame coordinates in the spritesheet
    int frame_x = current_frame % h_frames;
    int frame_y = current_frame / h_frames;

    // Calculate the size of each frame
    vec2 frame_size = vec2(1.0 / float(h_frames), 1.0 / float(v_frames));

    // Calculate the UV offset for the current frame
    vec2 uv_offset = vec2(frame_x, frame_y) * frame_size;

    // Adjust the UV coordinates to sample the correct frame
    vec2 uv = uv_offset + (FRAGCOORD.xy / vec2(textureGetWidth(texture), textureGetHeight(texture))) * frame_size;

    // Sample the texture and set the output color
    vec4 tex_color = texture(texture, uv);
    COLOR = tex_color;
}
