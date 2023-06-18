/**
 * Draws a ring shape.
 * 
 * @param normCoord Normalized, centered coordinates of the current pixel.
 * @param radius_px Ring radius.
 * @param thickness_px Ring thickness.
 * @param fade_px Additional thickness to fade out ring edges.
 * @return Distance to parametrized ring.
 */
float Ring(float centerDist, in float radius_px, in float thickness_px, in float fade_px)
{
    float signedDist = centerDist - radius_px;
    float absDist = abs(signedDist);
    
    return smoothstep(thickness_px, thickness_px + fade_px, absDist);
}

/**
 * This function is run for every pixel (standard function signature from GLSL).
 */
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // Normalize coordinates
    vec2 normCoord = fragCoord / iResolution.xy; // Places origin at bot-left corner, range [0, 1]
    normCoord = (normCoord - 0.5) * 2.0; // Move origin to center
    normCoord.x *= iResolution.x / iResolution.y; // Fix aspect ratio

    // Precomputed useful quantities
    float centerDist = length(normCoord);

    // Draw ring
    float ringDist = Ring(centerDist, 1.0, 0.2, 0.2);

    fragColor = vec4(ringDist, ringDist, 0.0, 1.0);

}