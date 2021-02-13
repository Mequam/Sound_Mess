shader_type canvas_item;
uniform vec4 colorA;
uniform vec4 colorB;
uniform vec4 colorC;
/*
	This shader functions as a color substitution function
	
	It accepts several input colors which are each associated with a specific set
	of rgb values NOT bieng 0.
	
	A color in out texture whose rgb value is not zero then has the magnitude of that color mapped
	onto the substitute color.
*/

//this function decodes the color magnitude from the input color
//that we scale the given color by
float getColorScale(vec4 color) {
	//fancy hack for the magnitude
	if (color.b > color.g && color.g > color.r)
		return color.b;
	else if (color.g > color.r)
		return color.g;
	return color.r;
}
vec4 getNewColor(vec4 oldColor,vec4 newColor) {
	newColor.xyz = newColor.xyz*getColorScale(oldColor);
	newColor.a += oldColor.a;
	//newColor.a = oldColor.a; //let the alpha carry through
	return newColor;
}
bool closeEnoughTo(vec3 color,vec3 target) {
	const float COLOR_CUTOFF = 0.709;
	return dot(color,target) >= COLOR_CUTOFF;
}
void fragment() {
	vec4 initialColor = texture(TEXTURE,UV);
	vec3 initialRGBNormal = normalize(initialColor.xyz);
	
	//we use the dot product with the normal of the color to tell if the color is "mostly"
	//pointing twoards the target
	//this accounts for anit-aliasing effects of the software feeding us the color
	COLOR = vec4(0.0,0.0,0.0,0.0);
	

	
	if (closeEnoughTo(initialRGBNormal,vec3(1,0,0))) {
		COLOR = getNewColor(initialColor,colorA);
	}
	else if (closeEnoughTo(initialRGBNormal,vec3(0,1,0))){
		COLOR = getNewColor(initialColor,colorB);
	}
	else if (closeEnoughTo(initialRGBNormal,normalize(vec3(1,0,1)))) {
		COLOR = getNewColor(initialColor,colorC);
	}
}