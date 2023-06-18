/**
 * Generate the RGB values corresponding to an orange-blue cosine gradient.
 *
 * @param centerDist Distance to origin of normalized coordinates.
 * @return [R, G, B] vector.
 */
vec3 OrangeBluePalette(in float centerDist)
{
    vec3 a = vec3(0.500, 0.500, 0.500);
    vec3 b = vec3(0.500, 0.500, 0.500);
    vec3 c = vec3(1.0, 1.0, 1.0); // vec3(1.00, 0.800, 0.500);
    vec3 d = vec3(0.25, 0.4, 0.55); // vec3(0.000, 0.200, 0.500);
    return a + b * cos(6.28318 * (c * centerDist + d));
}

/**
 * Draws a ring shape.
 * 
 * @param centerDist Distance to origin of normalized coordinates.
 * @param radius_px Ring radius.
 * @param thickness_px Ring thickness.
 * @param fade_px Additional thickness to fade out ring edges.
 * @return Distance to parametrized ring.
 */
float Ring(in float centerDist, in float radius_px, in float thickness_px, in float fade_px)
{
    float signedDist = centerDist - radius_px;
    float absDist = abs(signedDist);
    return smoothstep(thickness_px, thickness_px + fade_px, absDist);
}

/**
 * Draws repeated concentric rings.
 *
 * @param centerDist Distance to origin of normalized coordinates.
 * @param radius_px Ring radius.
 * @param thickness_px Ring thickness.
 * @param fade_px Additional thickness to fade out ring edges.
 * @param animate Whether to animate the rings moving or not.
 * @param expand If animating rings, whether to expand or contract them over time.
 * @return Distance to parametrized rings.
 */
float RepeatedRings(in float centerDist, in float frequency, in float thickness_px, in float fade_px, bool animate, bool expand) {
    float animationFactor = 0.0;
    if (animate) {
        animationFactor = iTime;
        if (expand) {
            animationFactor *= -1.0;
        }
    }
    float signedDist = sin(centerDist * frequency + animationFactor) / frequency;
    float absDist = abs(signedDist);
    float smoothDist = smoothstep(thickness_px, thickness_px + fade_px, absDist);
    float invDist = 0.025 / smoothDist;
    return invDist;
}

/**
 * Convert from normalized, centered coordinates to tiled, centered coordinates.
 *
 * @param normCoord Normalized, centered coordinate.
 * @param tileFactor Factor to use for fractional tiling. Use a higher value for more tiles.
 */
vec2 Normalized2TiledCoord(in vec2 normCoord, in float tileFactor)
{
    return fract(normCoord * tileFactor) - 0.5;
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

    // Drawing loop
    vec3 finalColor = vec3(0.0);
    vec2 tiledCoord = normCoord;
    for (float i = 0.0; i < 3.0; i++) {
        // Tiled normalized coordinates
        tiledCoord = Normalized2TiledCoord(tiledCoord, 1.7);

        // Precomputed useful quantities
        float centerDist = length(normCoord);
        float tiledCenterDist = length(tiledCoord);

        // Draw rings
        float repeatedRingDist = RepeatedRings(tiledCenterDist, 7.0, 0.0, 0.5, true, false);

        // Colors
        vec3 centerColorWave = OrangeBluePalette(centerDist - iTime * 0.5);
        finalColor += centerColorWave * repeatedRingDist;    
    }


    fragColor = vec4(finalColor, 1.0);
}