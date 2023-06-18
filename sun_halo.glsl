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
    float invDist = 0.03 / smoothDist;
    return invDist;
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
    vec3 colorBalance = vec3(1.0, 1.0, 1.0);

    // Draw ring
    float ringDist = Ring(centerDist, 0.5, 0.05, 0.0);

    float repeatedRingDist = RepeatedRings(centerDist, 4.0, 0.01, 0.5, true, true);

    fragColor = vec4(colorBalance * repeatedRingDist, 1.0);
//    fragColor = vec4(ringDist, ringDist, 0.0, 1.0);

}