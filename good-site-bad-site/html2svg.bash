#!/bin/bash
function remove_background() {
    cat <<- "EOM"
        // Remove background
        stylesheet(
            version="1.0",
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform",
            xmlns:svg="http://www.w3.org/2000/svg",
            xmlns:xlink="http://www.w3.org/1999/xlink",
            xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape",
            xmlns:sodipodi-ink="http://inkscape.sourceforge.net/DTD/sodipodi-0.dtd",
            xmlns:sodipodi-org="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd",
            xmlns:ai="http://ns.adobe.com/AdobeIllustrator/10.0/"
            xmlns:dc="http://purl.org/dc/elements/1.1/",
            xmlns:cc="http://web.resource.org/cc/",
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#",
        ) {
            output(method="xml", encoding="utf-8");

            // Remove background
            match("svg:*[contains(@style,'#feffff')]");

            // Parse every tag
            match("@*|node()") {
                copy() {
                    apply-templates("@*|node()");
                }
            }
        }
EOM
}

function optimize_svg() {
    cat <<- "EOM"
        // SVG optimization
        stylesheet(
            version="1.0",
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform",
            xmlns:svg="http://www.w3.org/2000/svg",
            xmlns:xlink="http://www.w3.org/1999/xlink",
            xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape",
            xmlns:sodipodi-ink="http://inkscape.sourceforge.net/DTD/sodipodi-0.dtd",
            xmlns:sodipodi-org="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd",
            xmlns:ai="http://ns.adobe.com/AdobeIllustrator/10.0/"
            xmlns:dc="http://purl.org/dc/elements/1.1/",
            xmlns:cc="http://web.resource.org/cc/",
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        ) {
            output(method="xml", encoding="utf-8");

            // Read the first number from a string
            // If the string does not start with a digit or a point, it returns
            // an empty string.
            // It is a recursive template.
            // Examples:
            // - "0.1234 4567" → "0.1234"
            // - " 1234" → ""
            template("read-number") {
                param $string;

                $first = "substring($string, 1, 1)";
                $digit = "translate($first, '0123456789.', '00000000000')";

                if("$digit = '0'") {
                    value-of("$first");
                    call-template("read-number") {
                        with-param $string="substring($string, 2)";
                    }
                }
            }

            // Reduce precision of a list of numbers contained in a string
            // It is a recursive template.
            // Examples:
            // - "1.23456, 2.468012, 0", 3 → "1.234, 2.468, 0"
            template("reduce-numbers") {
                param $string, $precision;

                // Tries to read a number from the string
                $number = {
                    call-template("read-number") {
                        with-param $string="$string";
                    }
                }
                
                choose() {
                    // A decimal number has been found
                    when("string-length($number) > 0 and contains($number, '.')") {
                        value-of("format-number($number, $precision)");

                        // Go on with the remaining of the string
                        call-template("reduce-numbers") {
                            with-param $string="substring-after($string, $number)",
                                       $precision="$precision";
                        }
                    }

                    // An integer has been found
                    when("string-length($number) > 0") {
                        value-of("$number");

                        // Go on with the remaining of the string
                        call-template("reduce-numbers") {
                            with-param $string="substring-after($string, $number)",
                                       $precision="$precision";
                        }
                    }

                    // A character not being a number has been found
                    when("string-length($string) > 0") {
                        // Send the first character to output
                        value-of("substring($string, 1, 1)");

                        // Go on with the remaining of the string
                        call-template("reduce-numbers") {
                            with-param $string="substring($string, 2)",
                                       $precision="$precision";
                        }
                    }

                    // Nothing’s left
                    otherwise();
                }
            }    

            // Optimize hexadecimal colors
            template("optimize-hexadecimal-color") {
                param $hexa;
                
                choose() {
                    when("    substring($hexa,2,1) = substring($hexa,3,1)
                          and substring($hexa,4,1) = substring($hexa,5,1)
                          and substring($hexa,6,1) = substring($hexa,7,1)") {
                        value-of("concat('#',
                                         substring($hexa,2,1),
                                         substring($hexa,4,1),
                                         substring($hexa,6,1))");
                    }
                    otherwise() {
                        value-of("$hexa");
                    }
                }
            }

            // Remove unnecessary tspan inside text tag
            match("svg:tspan[../@x = @x and ../@y = @y]") {
                apply-templates();
            }

            // Remove metadata
            match("svg:metadata");

            // Remove unused IDs
            match("@id") {
                $ref = "concat('#', .)";
            
                if("//@*[contains(., $ref)]") {
                    copy();
                }
            }

            // Remove empty defs or g
            match("svg:defs[not(descendant::*)]");
            match("svg:g[not(descendant::*)]");

            // Delete unused defs children
            match("svg:defs/*[not(@id)]");

            // Remove attributes set to default values
            match("@x[.='0']");
            match("@y[.='0']");
            match("@font-style[.='normal']");
            match("@font-style[.='normal']");
            match("@font-variant[.='normal']");
            match("@font-weight[.='normal']");
            match("@font-stretch[.='normal']");
            match("@font-size[.='medium']");
            match("@font-size-adjust[.='none']");
            match("@kerning[.='auto']");
            match("@letter-spacing[.='normal']");
            match("@word-spacing[.='normal']");
            match("@text-decoration[.='none']");
            match("@clip-rule[.='nonzero']");
            match("@fill-rule[.='nonzero']");
            match("@baseline-shift[.='baseline']");
            match("@dominant-baseline[.='auto']");
            match("@glyph-orientation-vertical[.='auto']");
            match("@marker[.='none']");
            match("@marker-end[.='none']");
            match("@marker-mid[.='none']");
            match("@marker-start[.='none']");
            match("@mask[.='none']");
            match("@stroke-linecap[.='butt']");
            match("@stroke-linejoin[.='miter']");
            match("@baseProfile[.='none']");
            match("@preserveAspectRatio[.='xMidYMid meet']");
            match("@externalResourcesRequired[.='false']");
            match("svg:svg/@width[.='100%']");
            match("svg:svg/@height[.='100%']");

            // Optimize hexadecimal colors
            match("@stroke|@fill") {
                $value = {
                    call-template("optimize-hexadecimal-color") {
                        with-param $hexa = ".";
                    }
                }

                attribute("{name()}") {
                    value-of("normalize-space($value)");
                }
            }

            // Reduce numbers precision
            match("@font-size|@transform|@x|@y|@x1|@x2|@y1|@y2|@d|@r|@fx|@fy|@svg:cx|
                   @svg:cy|@gradientTransform|@width|@height|@style") {
                $value = {
                    call-template("reduce-numbers") {
                        with-param $string=".", $precision="'0.###'";
                    }
                }

                attribute("{name()}") {
                    value-of("normalize-space($value)");
                }
            }

            // Remove Inkscape or Sodipodi tags or attributes
            match("@inkscape:*");
            match("@sodipodi-ink:*|@sodipodi-org:*");
            match("inkscape:*");
            match("sodipodi-ink:*|sodipodi-org:*");

            // Remove Adobe Illustrator tags or attributes
            match("@ai:*");
            match("ai:*");

            // Remove foreign objects
            match("svg:foreignObject");

            // Remove unneeded text
            match("svg:text/text()|svg:tspan/text()|svg:script/text()") {
                value-of(".");
            }

            match("text()");

            // Remove comments
            match("comment()");

            // Parse every tag
            match("@*|node()") {
                copy() {
                    apply-templates("@*|node()");
                }
            }
        }
EOM
}

function hide_gtk_messages() { 
    egrep --invert-match --ignore-case 'Gtk-(Message|Warning)'
}

function hide_chromium_messages() {
    egrep --invert-match --ignore-case ':INFO:'
}

HTML="$1"
PDFTMP="$1.pdf"
SVG="$1.svg"
SVGTMP="$1.svg.tmp"

# Convert HTML to PDF
printf "  - [CHROMIUM] Converting HTML to PDF\n"
#google-chrome \
chromium-browser \
    --headless \
    --disable-gpu \
    --print-to-pdf-no-header \
    --print-to-pdf="$PDFTMP" \
    "$HTML" \
    2>&1 | hide_chromium_messages

# Convert PDF to SVG
printf "  - [INKSCAPE] Converting PDF to SVG\n"
inkscape --without-gui --export-plain-svg="$SVGTMP" "$PDFTMP" \
    2>&1 | hide_gtk_messages

# Remove background
printf "  - [XSLTPROC] Removing background in SVG\n"
xsltproc <(remove_background | xslclearer) "$SVGTMP" > "$SVG"

# Auto crop
printf "  - [INKSCAPE] Auto-cropping SVG\n"
inkscape --without-gui --export-area-drawing --export-pdf="$PDFTMP" "$SVG" \
    2>&1 | hide_gtk_messages
inkscape --without-gui --export-plain-svg="$SVGTMP" "$PDFTMP" \
    2>&1 | hide_gtk_messages
#inkscape --without-gui --export-area-drawing --export-plain-svg="$SVGTMP" "$SVG" \
#    2>&1 | hide_gtk_messages

# Optimize SVG
printf "  - [XSLTPROC] Optimizing SVG\n"
xsltproc <(optimize_svg | xslclearer) "$SVGTMP" > "$SVG"

rm -f "$SVGTMP" "$PDFTMP"
