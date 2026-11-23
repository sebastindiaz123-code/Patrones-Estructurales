# Genera la presentacion de Bridge & Flyweight (PowerPoint, 16:9)
# Requiere Windows + Microsoft PowerPoint instalado.
# Uso:  powershell -ExecutionPolicy Bypass -File generate-slides.ps1

$ErrorActionPreference = "Stop"

# ---------------------------------------------------------------- utilidades
function C([int]$r, [int]$g, [int]$b) {
    return $r -bor ($g -shl 8) -bor ($b -shl 16)
}

$CL_BG      = C 11 18 32
$CL_CARD    = C 22 32 54
$CL_CARD2   = C 17 26 45
$CL_BORDER  = C 51 65 85
$CL_TEXT    = C 230 237 247
$CL_MUTED   = C 148 163 184
$CL_ACCENT  = C 56 189 248
$CL_ACCENT2 = C 167 139 250
$CL_AMBER   = C 251 191 36
$CL_GREEN   = C 52 211 153
$CL_RED     = C 248 113 113
$CL_CODE    = C 13 21 38
$CL_CODE_TX = C 214 228 245

$script:W = 960
$script:H = 540

function Add-Text {
    param(
        $s, $x, $y, $w, $h, $txt,
        [double]$size = 12,
        [int]$color = 0,
        [bool]$bold = $false,
        [string]$font = "Segoe UI",
        [int]$align = 1,
        [int]$anchor = 1,
        [double]$spacing = 1.0
    )
    if ($color -eq 0) { $color = $CL_TEXT }
    $sh = $s.Shapes.AddTextbox(1, $x, $y, $w, $h)
    $tf = $sh.TextFrame
    $tf.WordWrap = -1
    $tf.AutoSize = 0
    $tf.MarginLeft = 0
    $tf.MarginRight = 0
    $tf.MarginTop = 0
    $tf.MarginBottom = 0
    $tf.VerticalAnchor = $anchor
    $tr = $tf.TextRange
    $tr.Text = $txt
    $tr.Font.Name = $font
    $tr.Font.Size = $size
    if ($bold) { $tr.Font.Bold = -1 } else { $tr.Font.Bold = 0 }
    $tr.Font.Color.RGB = $color
    $tr.ParagraphFormat.Alignment = $align
    if ($spacing -ne 1.0) { $tr.ParagraphFormat.SpaceWithin = $spacing }
    return $sh
}

function Add-Card {
    param($s, $x, $y, $w, $h, $fill, $border = 0, [double]$radius = 0.06)
    $sh = $s.Shapes.AddShape(5, $x, $y, $w, $h)
    $sh.Fill.Solid()
    $sh.Fill.ForeColor.RGB = $fill
    if ($border -eq 0) {
        $sh.Line.Visible = 0
    } else {
        $sh.Line.Visible = -1
        $sh.Line.ForeColor.RGB = $border
        $sh.Line.Weight = 1
    }
    $sh.Adjustments.Item(1) = $radius
    $sh.Shadow.Visible = 0
    $sh.TextFrame.TextRange.Text = ""
    return $sh
}

function Add-Line {
    param($s, $x1, $y1, $x2, $y2, $color = 0, [double]$weight = 1.0, [int]$dash = 1, [int]$begin = 0, [int]$end = 0)
    if ($color -eq 0) { $color = $CL_BORDER }
    $ln = $s.Shapes.AddConnector(1, $x1, $y1, $x2, $y2)
    $ln.Line.ForeColor.RGB = $color
    $ln.Line.Weight = $weight
    $ln.Line.DashStyle = $dash
    $ln.Line.BeginArrowheadStyle = $begin + 1
    $ln.Line.EndArrowheadStyle = $end + 1
    return $ln
}

function Add-Glow {
    param($s, $x, $y, $d, $color, [double]$alpha = 0.92)
    $o = $s.Shapes.AddShape(9, $x, $y, $d, $d)
    $o.Line.Visible = 0
    $o.Fill.Solid()
    $o.Fill.ForeColor.RGB = $color
    $o.Fill.Transparency = $alpha
    return $o
}

function Add-Background {
    param($s)
    $s.FollowMasterBackground = 0
    $s.Background.Fill.Solid()
    $s.Background.Fill.ForeColor.RGB = $CL_BG
}

function Add-Header {
    param($s, $eyebrow, $title, $subtitle = "")
    $bar = $s.Shapes.AddShape(1, 48, 40, 4, 28)
    $bar.Line.Visible = 0
    $bar.Fill.Solid()
    $bar.Fill.ForeColor.RGB = $CL_ACCENT

    Add-Text $s 64 37 760 14 $eyebrow 8.5 $CL_ACCENT $true | Out-Null
    Add-Text $s 63 50 790 40 $title 27 $CL_TEXT $true | Out-Null
    if ($subtitle -ne "") {
        Add-Text $s 64 91 800 18 $subtitle 11.5 $CL_MUTED | Out-Null
    }

    $ln = $s.Shapes.AddConnector(1, 48, 127, 912, 127)
    $ln.Line.ForeColor.RGB = $CL_BORDER
    $ln.Line.Weight = 0.75
}

function Add-Footer {
    param($s, $n)
    $ln = $s.Shapes.AddConnector(1, 48, 508, 912, 508)
    $ln.Line.ForeColor.RGB = $CL_BORDER
    $ln.Line.Weight = 0.5
    Add-Text $s 48 513 600 12 "Patrones Estructurales  ·  Bridge & Flyweight" 8 $CL_MUTED | Out-Null
    Add-Text $s 860 513 52 12 ("{0:D2}" -f $n) 8 $CL_MUTED $false "Segoe UI" 3 | Out-Null
}

function Add-Diamond {
    param($s, $cx, $cy, [double]$size = 12)
    $d = $s.Shapes.AddShape(4, $cx - $size / 2, $cy - $size / 2, $size, $size)
    $d.Fill.Solid()
    $d.Fill.ForeColor.RGB = $CL_BG
    $d.Line.ForeColor.RGB = $CL_ACCENT
    $d.Line.Weight = 1
    $d.Shadow.Visible = 0
    return $d
}

function Add-ClassBox {
    param($s, $x, $y, $w, $h, $stereo, $name, $body, $accent = 0)
    if ($accent -eq 0) { $accent = $CL_ACCENT }
    $card = Add-Card $s $x $y $w $h $CL_CARD $CL_BORDER 0.035
    $strip = $s.Shapes.AddShape(1, $x, $y, $w, 3)
    $strip.Line.Visible = 0
    $strip.Fill.Solid()
    $strip.Fill.ForeColor.RGB = $accent

    $headerH = 30
    if ($stereo -ne "") {
        Add-Text $s ($x + 6) ($y + 8) ($w - 12) 12 ("«" + $stereo + "»") 7.5 $accent $false "Segoe UI" 2 | Out-Null
        Add-Text $s ($x + 6) ($y + 20) ($w - 12) 16 $name 10 $CL_TEXT $true "Segoe UI" 2 | Out-Null
        $headerH = 38
    } else {
        Add-Text $s ($x + 6) ($y + 10) ($w - 12) 18 $name 10 $CL_TEXT $true "Segoe UI" 2 | Out-Null
    }

    $ln = $s.Shapes.AddConnector(1, $x + 1, $y + $headerH, $x + $w - 1, $y + $headerH)
    $ln.Line.ForeColor.RGB = $CL_BORDER
    $ln.Line.Weight = 0.75

    if ($body -ne "") {
        Add-Text $s ($x + 9) ($y + $headerH + 7) ($w - 18) ($h - $headerH - 10) $body 8.2 $CL_MUTED $false "Consolas" | Out-Null
    }
    return $card
}

function Add-Bullets {
    param($s, $x, $y, $w, $h, $items, [double]$size = 10.5, $color = 0, [double]$spacing = 1.25)
    if ($color -eq 0) { $color = $CL_TEXT }
    $txt = ($items | ForEach-Object { "•  " + $_ }) -join "`r"
    Add-Text $s $x $y $w $h $txt $size $color $false "Segoe UI" 1 1 $spacing | Out-Null
}

function Add-Notes {
    param($s, $txt)
    try {
        $body = $s.NotesPage.Shapes.Placeholders.Item(2)
        $body.TextFrame.TextRange.Text = $txt
        $body.TextFrame.TextRange.Font.Size = 11
    } catch { }
}

$codeKeywords = @(
    "public", "private", "protected", "static", "final", "abstract", "class", "interface",
    "extends", "implements", "new", "return", "void", "if", "else", "for", "while",
    "this", "super", "null", "true", "false", "import", "package", "throws", "throw",
    "try", "catch", "record", "enum"
)
$codeTypes = @("String", "int", "double", "long", "byte", "boolean", "char", "Map", "HashMap", "List", "Set", "ArrayList", "Object")

function Add-Code {
    param($s, $x, $y, $w, $h, $code, [double]$size = 9.8, [string]$label = "JAVA")

    $card = Add-Card $s $x $y $w $h $CL_CODE $CL_BORDER 0.03

    # barra superior con tres puntos
    $dotColors = @($CL_RED, $CL_AMBER, $CL_GREEN)
    for ($i = 0; $i -lt 3; $i++) {
        $dot = $s.Shapes.AddShape(9, $x + 14 + ($i * 12), $y + 13, 6, 6)
        $dot.Line.Visible = 0
        $dot.Fill.Solid()
        $dot.Fill.ForeColor.RGB = $dotColors[$i]
    }
    Add-Text $s ($x + $w - 92) ($y + 9) 78 12 $label 7.5 $CL_MUTED $true "Segoe UI" 3 | Out-Null

    $code = $code -replace "`r`n", "`n"
    $code = $code -replace "`n", "`r"

    $tb = $s.Shapes.AddTextbox(1, $x + 18, $y + 32, $w - 34, $h - 42)
    $tf = $tb.TextFrame
    $tf.WordWrap = -1
    $tf.AutoSize = 0
    $tf.MarginLeft = 0
    $tf.MarginRight = 0
    $tf.MarginTop = 0
    $tf.MarginBottom = 0
    $tr = $tf.TextRange
    $tr.Text = $code
    $tr.Font.Name = "Consolas"
    $tr.Font.Size = $size
    $tr.Font.Color.RGB = $CL_CODE_TX

    $pattern = '("(?:\\.|[^""\\])*"|//[^\r\n]*|/\*[\s\S]*?\*/|@[A-Za-z]+|\b(?:public|private|protected|static|final|abstract|class|interface|extends|implements|new|return|void|if|else|for|while|this|super|null|true|false|import|package|throws|throw|try|catch)\b|\b(?:String|int|double|long|byte|boolean|char|Map|HashMap|List|Set|ArrayList|Object)\b|\b\d+L?\b)'
    $parts = [regex]::Split($code, $pattern)
    $pos = 1
    foreach ($p in $parts) {
        if ([string]::IsNullOrEmpty($p)) { continue }
        $col = $CL_CODE_TX
        if ($p.StartsWith("//") -or $p.StartsWith("/*")) { $col = C 106 153 85 }
        elseif ($p.StartsWith('"')) { $col = C 252 165 165 }
        elseif ($p.StartsWith("@")) { $col = $CL_ACCENT2 }
        elseif ($p -match '^\d') { $col = $CL_AMBER }
        elseif ($codeTypes -contains $p) { $col = $CL_AMBER }
        elseif ($codeKeywords -contains $p) { $col = $CL_ACCENT }
        $r = $tr.Characters($pos, $p.Length)
        $r.Font.Color.RGB = $col
        $pos += $p.Length
    }
    return $card
}

# ---------------------------------------------------------------- presentacion
$ppt = New-Object -ComObject PowerPoint.Application
$ppt.Visible = -1
$ppt.DisplayAlerts = 1

$pres = $ppt.Presentations.Add()
$pres.PageSetup.SlideWidth = 960
$pres.PageSetup.SlideHeight = 540

$slideIndex = 0
function New-Slide {
    $script:slideIndex++
    $s = $pres.Slides.Add($pres.Slides.Count + 1, 12)
    Add-Background $s
    return $s
}

# ============================================================ 01 PORTADA
$s = New-Slide
Add-Glow $s 620 -120 560 $CL_ACCENT 0.94 | Out-Null
Add-Glow $s 760 260 360 $CL_ACCENT2 0.95 | Out-Null

Add-Text $s 72 66 520 16 "PATRONES DE DISEÑO  ·  GOF" 9 $CL_ACCENT $true | Out-Null
Add-Text $s 68 96 520 120 "Patrones`rEstructurales" 46 $CL_TEXT $true "Segoe UI" 1 1 0.92 | Out-Null

$bar = $s.Shapes.AddShape(1, 72, 232, 110, 5)
$bar.Line.Visible = 0
$bar.Fill.Solid()
$bar.Fill.ForeColor.RGB = $CL_ACCENT

Add-Text $s 72 258 500 64 "Bridge y Flyweight: desacoplar lo que cambia`ry compartir lo que se repite." 17 $CL_MUTED $false "Segoe UI" 1 1 1.15 | Out-Null

Add-Text $s 72 404 520 16 "Programación Orientada a Objetos  ·  Java" 11.5 $CL_TEXT | Out-Null
Add-Text $s 72 428 520 16 "Integrantes: ______________________________" 11.5 $CL_MUTED | Out-Null
Add-Text $s 72 452 520 16 "Noviembre 2026" 11.5 $CL_MUTED | Out-Null

# mini diagrama: Bridge
Add-ClassBox $s 590 168 150 52 "" "Shape" "" | Out-Null
Add-ClassBox $s 778 168 150 52 "" "Renderer" "" $CL_ACCENT2 | Out-Null
Add-Line $s 740 194 778 194 $CL_ACCENT 1.2 1 0 1 | Out-Null
Add-Diamond $s 746 194 11 | Out-Null
Add-Text $s 590 228 150 14 "Abstracción" 8 $CL_MUTED $false "Segoe UI" 2 | Out-Null
Add-Text $s 778 228 150 14 "Implementación" 8 $CL_MUTED $false "Segoe UI" 2 | Out-Null

$sep = $s.Shapes.AddConnector(1, 590, 262, 928, 262)
$sep.Line.ForeColor.RGB = $CL_BORDER
$sep.Line.Weight = 0.75

# mini diagrama: Flyweight
Add-ClassBox $s 676 292 190 64 "flyweight" "TreeType" "" $CL_ACCENT2 | Out-Null
$treeXs = @(600, 700, 800)
foreach ($tx in $treeXs) {
    Add-Card $s $tx 424 80 38 $CL_CARD $CL_BORDER 0.12 | Out-Null
    Add-Text $s $tx 433 80 20 "árbol" 8 $CL_MUTED $false "Segoe UI" 2 | Out-Null
    Add-Line $s ($tx + 40) 424 771 356 $CL_BORDER 0.8 4 | Out-Null
}
Add-Text $s 590 478 336 14 "una textura, miles de árboles" 8 $CL_MUTED $false "Segoe UI" 2 | Out-Null

Add-Notes $s "Buenos días. Somos [nombres]. Hoy exponemos dos patrones estructurales: Bridge y Flyweight. La idea central de la charla es simple: cómo desacoplar dos cosas que cambian por separado y cómo compartir lo que se repite para ahorrar memoria. Al final dejamos el cuadro comparativo de los siete patrones y el código en GitHub."

# ============================================================ 02 AGENDA
$s = New-Slide
Add-Header $s "AGENDA" "Ruta de la exposición" "Cuatro bloques, una idea: estructuras más flexibles con menos costo." | Out-Null

$agenda = @(
    @("01", "Introducción", "Qué son los patrones de diseño y qué distingue a los estructurales.", "≈ 3 min"),
    @("02", "Bridge", "Separar la abstracción de la implementación en dos jerarquías.", "≈ 3 min"),
    @("03", "Flyweight", "Compartir estado inmutable para sostener miles de objetos.", "≈ 4 min"),
    @("04", "Conclusiones", "Cuadro comparativo de los 7 patrones y guía de elección.", "≈ 2 min")
)
for ($i = 0; $i -lt 4; $i++) {
    $x = 48 + ($i * 220)
    $card = Add-Card $s $x 165 204 245 $CL_CARD $CL_BORDER 0.05
    $strip = $s.Shapes.AddShape(1, $x, 165, 204, 4)
    $strip.Line.Visible = 0
    $strip.Fill.Solid()
    $strip.Fill.ForeColor.RGB = $CL_ACCENT
    Add-Text $s ($x + 18) 182 120 40 $agenda[$i][0] 28 $CL_ACCENT $true | Out-Null
    Add-Text $s ($x + 18) 228 170 24 $agenda[$i][1] 14 $CL_TEXT $true | Out-Null
    Add-Text $s ($x + 18) 258 170 100 $agenda[$i][2] 9.8 $CL_MUTED | Out-Null
    Add-Text $s ($x + 18) 378 170 14 $agenda[$i][3] 8.5 $CL_ACCENT2 $true | Out-Null
}

Add-Card $s 48 432 864 52 $CL_CARD2 0 0.12 | Out-Null
Add-Text $s 70 448 820 22 "Incluye demo en vivo: un bosque de 200.000 árboles y el código completo en GitHub." 11 $CL_MUTED | Out-Null
Add-Footer $s $slideIndex

Add-Notes $s "Este es el recorrido. Primero el marco conceptual, después los dos patrones y al final la comparación con los otros cinco. La demo de Flyweight la hacemos en vivo al terminar esa sección."

# ============================================================ 03 QUE SON
$s = New-Slide
Add-Header $s "INTRODUCCIÓN" "¿Qué son los patrones de diseño?" "Soluciones reutilizables a problemas recurrentes de diseño de software." | Out-Null

Add-Card $s 48 150 556 152 $CL_CARD $CL_BORDER 0.05 | Out-Null
Add-Text $s 72 168 508 76 "No son código ni librerías: son plantillas de solución que se adaptan a cada contexto. Describen un problema, una solución y sus consecuencias." 12.5 $CL_TEXT | Out-Null
Add-Text $s 72 262 508 16 "— Design Patterns, Gamma, Helm, Johnson y Vlissides (GoF, 1994)" 8.8 $CL_MUTED | Out-Null

$stats = @(
    @("23", "patrones clásicos"),
    @("3", "familias"),
    @("+30", "años de vigencia")
)
for ($i = 0; $i -lt 3; $i++) {
    $y = 150 + ($i * 54)
    Add-Card $s 624 $y 288 46 $CL_CARD2 $CL_BORDER 0.12 | Out-Null
    Add-Text $s 642 ($y + 10) 60 26 $stats[$i][0] 18 $CL_ACCENT $true | Out-Null
    Add-Text $s 706 ($y + 15) 190 18 $stats[$i][1] 10 $CL_MUTED | Out-Null
}

$families = @(
    @("Creacionales", "5", "Cómo crear objetos sin acoplar el código a las clases concretas.", $false),
    @("Estructurales", "7", "Cómo componer clases y objetos en estructuras más grandes y flexibles.", $true),
    @("De comportamiento", "11", "Cómo colaboran los objetos y cómo se reparten responsabilidades.", $false)
)
for ($i = 0; $i -lt 3; $i++) {
    $x = 48 + ($i * 292)
    $border = 0
    if ($families[$i][3]) { $border = $CL_ACCENT }
    Add-Card $s $x 326 280 150 $CL_CARD $border 0.05 | Out-Null
    $nameColor = $CL_TEXT
    if ($families[$i][3]) { $nameColor = $CL_ACCENT }
    Add-Text $s ($x + 18) 344 190 22 $families[$i][0] 13.5 $nameColor $true | Out-Null
    Add-Text $s ($x + 236) 346 28 20 $families[$i][1] 14 $CL_ACCENT2 $true "Segoe UI" 3 | Out-Null
    Add-Text $s ($x + 18) 376 244 70 $families[$i][2] 9.8 $CL_MUTED | Out-Null
    if ($families[$i][3]) {
        Add-Text $s ($x + 18) 446 244 14 "NUESTRA PARTE" 8 $CL_ACCENT $true | Out-Null
    }
}
Add-Footer $s $slideIndex

Add-Notes $s "Un patrón no es una receta que se copia: es vocabulario. El libro del GoF de 1994 recopiló 23 patrones y los organizó en tres familias: creacionales, estructurales y de comportamiento. Nosotros estamos en la familia estructural, la del medio."

# ============================================================ 04 ESTRUCTURALES
$s = New-Slide
Add-Header $s "INTRODUCCIÓN" "¿Qué son los patrones estructurales?" "Se enfocan en cómo se componen clases y objetos para formar estructuras mayores." | Out-Null

Add-Card $s 48 145 424 122 $CL_CARD $CL_BORDER 0.05 | Out-Null
Add-Text $s 68 160 384 18 "Estructurales de clases" 12.5 $CL_TEXT $true | Out-Null
Add-Text $s 68 184 384 48 "Usan herencia e interfaces para adaptar o separar abstracciones." 9.8 $CL_MUTED | Out-Null
Add-Text $s 68 238 384 16 "Adapter  ·  Bridge" 9.5 $CL_ACCENT $true | Out-Null

Add-Card $s 488 145 424 122 $CL_CARD $CL_BORDER 0.05 | Out-Null
Add-Text $s 508 160 384 18 "Estructurales de objetos" 12.5 $CL_TEXT $true | Out-Null
Add-Text $s 508 184 384 48 "Usan composición y delegación en tiempo de ejecución." 9.8 $CL_MUTED | Out-Null
Add-Text $s 508 238 384 16 "Composite · Decorator · Facade · Flyweight · Proxy" 9.5 $CL_ACCENT2 $true | Out-Null

$patterns = @(
    @("Adapter", "Conecta interfaces incompatibles.", $false),
    @("Bridge", "Separa abstracción e implementación.", $true),
    @("Composite", "Estructuras de árbol parte-todo.", $false),
    @("Decorator", "Añade comportamiento envolviendo.", $false),
    @("Facade", "Una puerta simple al subsistema.", $false),
    @("Flyweight", "Comparte estado inmutable.", $true),
    @("Proxy", "Sustituto que controla el acceso.", $false)
)
for ($i = 0; $i -lt 7; $i++) {
    $x = 48 + ($i * 127)
    $border = 0
    if ($patterns[$i][2]) { $border = $CL_ACCENT }
    Add-Card $s $x 292 118 148 $CL_CARD $border 0.06 | Out-Null
    $nameColor = $CL_TEXT
    if ($patterns[$i][2]) { $nameColor = $CL_ACCENT }
    Add-Text $s ($x + 10) 306 98 20 $patterns[$i][0] 10.5 $nameColor $true | Out-Null
    Add-Text $s ($x + 10) 332 98 92 $patterns[$i][1] 8.2 $CL_MUTED | Out-Null
}
Add-Text $s 48 456 864 16 "Bridge y Flyweight son los dos patrones que exponemos hoy; los otros cinco completan la familia." 10 $CL_MUTED | Out-Null
Add-Footer $s $slideIndex

Add-Notes $s "Los estructurales se dividen en dos: los de clases, que usan herencia, y los de objetos, que usan composición. La regla moderna es preferir composición sobre herencia. Aquí están los siete. Hoy profundizamos en dos: Bridge, que separa dos jerarquías, y Flyweight, que comparte estado."

# ============================================================ 05 PARA QUE SIRVEN
$s = New-Slide
Add-Header $s "INTRODUCCIÓN" "¿Para qué sirven en la práctica?" "No se trata de usar más patrones, sino de reducir el costo del cambio." | Out-Null

$benefits = @(
    @("01", "Desacoplan", "Separan lo que es estable de lo que cambia, para que un cambio no se propague por todo el sistema."),
    @("02", "Simplifican", "El cliente habla con una interfaz clara y deja de conocer los detalles internos."),
    @("03", "Reutilizan", "Composición y delegación en lugar de duplicar jerarquías de clases."),
    @("04", "Optimizan", "Menos objetos, menos memoria y menos dependencias entre módulos.")
)
for ($i = 0; $i -lt 4; $i++) {
    $col = $i % 2
    $row = [math]::Floor($i / 2)
    $x = 48 + ($col * 444)
    $y = 150 + ($row * 134)
    Add-Card $s $x $y 420 120 $CL_CARD $CL_BORDER 0.05 | Out-Null
    Add-Text $s ($x + 18) ($y + 16) 46 26 $benefits[$i][0] 20 $CL_ACCENT $true | Out-Null
    Add-Text $s ($x + 68) ($y + 18) 330 22 $benefits[$i][1] 13 $CL_TEXT $true | Out-Null
    Add-Text $s ($x + 18) ($y + 56) 384 54 $benefits[$i][2] 9.8 $CL_MUTED | Out-Null
}

Add-Card $s 48 424 864 62 (C 35 29 20) $CL_AMBER 0.08 | Out-Null
Add-Text $s 70 438 820 36 "!  Un patrón mal aplicado también es deuda técnica: primero identifica el problema, después el patrón." 11.5 (C 253 230 138) $true | Out-Null
Add-Footer $s $slideIndex

Add-Notes $s "Los patrones no son un fin. Sirven si reducen el costo del cambio: desacoplan, simplifican, reutilizan y a veces optimizan. La advertencia es importante: aplicar un patrón sin un problema real agrega complejidad. Primero el problema, después el nombre."

# ============================================================ 06 BRIDGE PROBLEMA
$s = New-Slide
Add-Header $s "PATRÓN 01  ·  BRIDGE" "El problema: dos dimensiones, una explosión de clases" "Cada figura necesita una clase por cada forma de dibujarla." | Out-Null

Add-Card $s 48 148 250 296 $CL_CARD $CL_BORDER 0.04 | Out-Null
Add-Text $s 66 160 210 14 "DIMENSIÓN A" 8 $CL_ACCENT $true | Out-Null
Add-Text $s 66 174 210 20 "Figura" 13.5 $CL_TEXT $true | Out-Null

Add-Card $s 66 200 80 26 $CL_CARD2 $CL_BORDER 0.2 | Out-Null
Add-Text $s 66 205 80 16 "Círculo" 8.8 $CL_TEXT $false "Segoe UI" 2 | Out-Null
Add-Card $s 154 200 84 26 $CL_CARD2 $CL_BORDER 0.2 | Out-Null
Add-Text $s 154 205 84 16 "Cuadrado" 8.8 $CL_TEXT $false "Segoe UI" 2 | Out-Null
Add-Card $s 66 234 96 26 $CL_CARD2 $CL_BORDER 0.2 | Out-Null
Add-Text $s 66 239 96 16 "Triángulo" 8.8 $CL_TEXT $false "Segoe UI" 2 | Out-Null

$ln = $s.Shapes.AddConnector(1, 66, 272, 280, 272)
$ln.Line.ForeColor.RGB = $CL_BORDER
$ln.Line.Weight = 0.75

Add-Text $s 66 282 210 14 "DIMENSIÓN B" 8 $CL_ACCENT2 $true | Out-Null
Add-Text $s 66 296 210 20 "Renderizador" 13.5 $CL_TEXT $true | Out-Null
Add-Card $s 66 322 96 26 $CL_CARD2 $CL_BORDER 0.2 | Out-Null
Add-Text $s 66 327 96 16 "Vectorial" 8.8 $CL_TEXT $false "Segoe UI" 2 | Out-Null
Add-Card $s 170 322 110 26 $CL_CARD2 $CL_BORDER 0.2 | Out-Null
Add-Text $s 170 327 110 16 "Rasterizado" 8.8 $CL_TEXT $false "Segoe UI" 2 | Out-Null

Add-Text $s 66 358 210 26 "3 × 2 = 6 clases" 16 $CL_AMBER $true | Out-Null
Add-Text $s 66 390 210 34 "Sin contar la clase base. La herencia multiplica el código." 8.2 $CL_MUTED | Out-Null

Add-Line $s 308 220 340 220 $CL_ACCENT 1.5 1 0 1 | Out-Null
Add-Text $s 300 198 60 14 "herencia" 8 $CL_ACCENT $false "Segoe UI" 2 | Out-Null

$combos = @(
    @("CírculoVector", "Círculo", "Vectorial", $CL_ACCENT),
    @("CuadradoVector", "Cuadrado", "Vectorial", $CL_ACCENT),
    @("TriánguloVector", "Triángulo", "Vectorial", $CL_ACCENT),
    @("CírculoRaster", "Círculo", "Rasterizado", $CL_ACCENT2),
    @("CuadradoRaster", "Cuadrado", "Rasterizado", $CL_ACCENT2),
    @("TriánguloRaster", "Triángulo", "Rasterizado", $CL_ACCENT2)
)
for ($i = 0; $i -lt 6; $i++) {
    $col = $i % 3
    $row = [math]::Floor($i / 3)
    $x = 356 + ($col * 184)
    $y = 166 + ($row * 112)
    Add-Card $s $x $y 170 96 $CL_CARD $CL_BORDER 0.05 | Out-Null
    $strip = $s.Shapes.AddShape(1, $x, $y, 170, 3)
    $strip.Line.Visible = 0
    $strip.Fill.Solid()
    $strip.Fill.ForeColor.RGB = $combos[$i][3]
    Add-Text $s ($x + 12) ($y + 14) 146 18 $combos[$i][0] 9.5 $CL_TEXT $true | Out-Null
    Add-Text $s ($x + 12) ($y + 40) 146 14 ($combos[$i][1] + " + " + $combos[$i][2]) 7.8 $CL_MUTED | Out-Null
    Add-Text $s ($x + 12) ($y + 64) 146 20 "draw() duplicado" 8 (C 148 163 184) $false "Consolas" | Out-Null
}

Add-Card $s 48 456 864 44 (C 45 24 32) $CL_RED 0.12 | Out-Null
Add-Text $s 70 462 820 20 "+1 figura → +2 clases nuevas.   +1 renderizador → +3 clases nuevas." 11.5 (C 254 202 202) $true | Out-Null
Add-Text $s 70 481 820 14 "Con 5 figuras y 4 renderizadores serían 20 clases, y el código de dibujo se repite en cada una." 8.6 (C 233 170 170) | Out-Null
Add-Footer $s $slideIndex

Add-Notes $s "Aquí está el problema. Tenemos dos dimensiones que cambian por separado: la figura y la forma de dibujarla. Si usamos herencia, cada combinación es una clase: círculo vectorial, círculo raster, cuadrado vectorial... El crecimiento es multiplicativo. Agregar una figura obliga a crear una clase por cada renderizador, y el método draw se duplica."

# ============================================================ 07 BRIDGE SOLUCION UML
$s = New-Slide
Add-Header $s "PATRÓN 01  ·  BRIDGE" "La solución: separar y delegar" "Dos jerarquías independientes unidas por una referencia." | Out-Null

$badge = Add-Card $s 766 54 146 26 $CL_CARD $CL_ACCENT 0.2
Add-Text $s 766 59 146 16 "2 + 3 = 5 clases" 9.5 $CL_ACCENT $true "Segoe UI" 2 | Out-Null

Add-Card $s 48 142 864 330 $CL_CARD2 0 0.03 | Out-Null

Add-ClassBox $s 150 188 210 100 "abstract" "Shape" "# renderer: Renderer`r+ draw(): String`r+ area(): double" | Out-Null
Add-ClassBox $s 590 188 220 100 "interface" "Renderer" "+ circle(r): String`r+ square(s): String" $CL_ACCENT2 | Out-Null
Add-ClassBox $s 70 362 180 88 "" "Circle" "- radius: double`r+ draw(): String" | Out-Null
Add-ClassBox $s 270 362 180 88 "" "Square" "- side: double`r+ draw(): String" | Out-Null
Add-ClassBox $s 548 362 165 88 "" "VectorRenderer" "+ circle(...)`r+ square(...)" $CL_ACCENT2 | Out-Null
Add-ClassBox $s 735 362 165 88 "" "RasterRenderer" "+ circle(...)`r+ square(...)" $CL_ACCENT2 | Out-Null

Add-Line $s 360 238 590 238 $CL_ACCENT 1.3 1 0 0 | Out-Null
Add-Diamond $s 366 238 12 | Out-Null
Add-Text $s 440 218 140 14 "renderer" 8.5 $CL_ACCENT $false "Consolas" | Out-Null

Add-Line $s 160 362 215 288 $CL_ACCENT 1.1 4 0 2 | Out-Null
Add-Line $s 360 362 295 288 $CL_ACCENT 1.1 4 0 2 | Out-Null
Add-Line $s 630 362 665 288 $CL_ACCENT2 1.1 4 0 2 | Out-Null
Add-Line $s 817 362 735 288 $CL_ACCENT2 1.1 4 0 2 | Out-Null

Add-Text $s 64 452 832 14 "El rombo indica «tiene un»; la flecha punteada, «implementa». Shape no sabe cómo se dibuja: solo delega." 8.2 $CL_MUTED | Out-Null

Add-Text $s 48 482 864 18 "3 + 3 = 5 clases (no 6)  ·  cada eje crece de forma lineal: una figura nueva cuesta 1 clase, un renderizador nuevo cuesta 1 clase." 10.5 $CL_MUTED | Out-Null
Add-Footer $s $slideIndex

Add-Notes $s "Bridge propone separar las dos dimensiones. Shape es la abstracción y tiene una referencia a Renderer, el implementador. Circle y Square heredan de Shape; Vector y Raster implementan Renderer. Fíjense que Shape no sabe dibujar: delega en el renderer. Así las dos jerarquías crecen por separado. Con 3 figuras y 3 renderizadores pasamos de 9 combinaciones a 6 clases, y cada cosa nueva cuesta una sola clase."

# ============================================================ 08 BRIDGE CODIGO
$s = New-Slide
Add-Header $s "PATRÓN 01  ·  BRIDGE" "Código y criterios de uso" "La abstracción delega; el implementador hace el trabajo técnico." | Out-Null

$bridgeCode = @'
public interface Renderer {              // Implementor
    String circle(double radius);
}

public abstract class Shape {            // Abstraction
    protected final Renderer renderer;   // el puente

    protected Shape(Renderer renderer) {
        this.renderer = renderer;
    }

    public abstract String draw();
}

public class Circle extends Shape {      // RefinedAbstraction
    private final double radius;

    public Circle(double radius, Renderer renderer) {
        super(renderer);
        this.radius = radius;
    }

    @Override
    public String draw() {
        return renderer.circle(radius);  // delega
    }
}
'@
Add-Code $s 48 142 540 355 $bridgeCode 9.5 | Out-Null

Add-Text $s 612 148 300 14 "CUÁNDO USARLO" 8.5 $CL_ACCENT $true | Out-Null
Add-Bullets $s 612 170 300 104 @(
    "Dos dimensiones que varían por separado.",
    "Necesitas cambiar la implementación en runtime.",
    "Quieres ocultar la implementación al cliente."
) 9.8 $CL_TEXT 1.22 | Out-Null

Add-Text $s 612 286 300 14 "EN LA PRÁCTICA" 8.5 $CL_ACCENT2 $true | Out-Null
Add-Bullets $s 612 308 300 86 @(
    "JDBC: Connection ↔ Driver.",
    "AWT: componentes ↔ peers nativos.",
    "Notificaciones: tipo × canal (email, SMS)."
) 9.5 $CL_MUTED 1.2 | Out-Null

Add-Card $s 612 398 300 97 (C 35 29 20) $CL_AMBER 0.07 | Out-Null
Add-Text $s 628 410 268 14 "EL COSTO" 8 $CL_AMBER $true | Out-Null
Add-Text $s 628 430 268 54 "Más clases e indirección. Si solo hay una dimensión, la herencia simple es suficiente." 9.3 (C 253 230 138) | Out-Null
Add-Footer $s $slideIndex

Add-Notes $s "Este es el código mínimo. Renderer es la interfaz del implementador. Shape guarda la referencia y la recibe por constructor. Circle implementa draw delegando en renderer.circle. Para agregar un renderizador 3D solo creamos una clase que implemente Renderer; no tocamos las figuras. Se usa cuando hay dos ejes de cambio, cuando quieres cambiar la implementación en ejecución o cuando quieres esconderla. Ejemplo real: JDBC, donde Connection es la abstracción y Driver la implementación."

# ============================================================ 09 FLYWEIGHT PROBLEMA
$s = New-Slide
Add-Header $s "PATRÓN 02  ·  FLYWEIGHT" "El problema: miles de objetos que repiten lo mismo" "En un bosque, la especie, el color y la textura se repiten árbol tras árbol." | Out-Null

$stats = @(
    @("200.000", "árboles en el bosque"),
    @("4", "especies distintas"),
    @("2 KB", "por textura")
)
for ($i = 0; $i -lt 3; $i++) {
    $x = 48 + ($i * 294)
    Add-Card $s $x 145 270 78 $CL_CARD $CL_BORDER 0.06 | Out-Null
    Add-Text $s ($x + 18) 158 234 30 $stats[$i][0] 21 $CL_ACCENT $true | Out-Null
    Add-Text $s ($x + 18) 194 234 16 $stats[$i][1] 9.5 $CL_MUTED | Out-Null
}

Add-Card $s 48 240 530 204 $CL_CARD $CL_BORDER 0.04 | Out-Null
Add-Text $s 68 254 490 16 "SIN FLYWEIGHT" 8.5 $CL_RED $true | Out-Null
Add-Text $s 68 272 490 18 "Cada árbol carga su propia copia de la textura" 10.5 $CL_TEXT | Out-Null

$rows = @(
    @("Roble verde", "× 50.000"),
    @("Pino oscuro", "× 50.000"),
    @("Sauce claro", "× 50.000"),
    @("Cerezo rosa", "× 50.000")
)
for ($i = 0; $i -lt 4; $i++) {
    $y = 302 + ($i * 26)
    Add-Card $s 68 $y 490 22 $CL_CARD2 0 0.2 | Out-Null
    Add-Text $s 80 ($y + 3) 240 16 ($rows[$i][0] + "  ·  textura 2 KB") 8.5 $CL_MUTED | Out-Null
    Add-Text $s 440 ($y + 3) 104 16 $rows[$i][1] 8.5 $CL_MUTED $false "Segoe UI" 3 | Out-Null
}
Add-Text $s 68 416 490 16 "… × 200.000  =  ≈ 400 MB" 13 $CL_RED $true | Out-Null

Add-Card $s 596 240 316 204 $CL_CARD $CL_BORDER 0.04 | Out-Null
Add-Text $s 614 254 280 16 "¿QUÉ SE REPITE?" 8.5 $CL_ACCENT $true | Out-Null
Add-Text $s 614 276 280 14 "INTRÍNSECO  ·  compartido" 7.8 $CL_ACCENT $true | Out-Null
Add-Text $s 614 294 280 20 "especie  ·  color  ·  textura" 10.5 $CL_TEXT | Out-Null
$ln = $s.Shapes.AddConnector(1, 614, 326, 894, 326)
$ln.Line.ForeColor.RGB = $CL_BORDER
$ln.Line.Weight = 0.75
Add-Text $s 614 340 280 14 "EXTRÍNSECO  ·  único" 7.8 $CL_ACCENT2 $true | Out-Null
Add-Text $s 614 358 280 20 "x  ·  y" 10.5 $CL_TEXT | Out-Null
Add-Text $s 614 400 280 34 "Solo la posición cambia de un árbol a otro. Todo lo demás es idéntico." 8.8 $CL_MUTED | Out-Null

Add-Card $s 48 456 864 38 (C 45 24 32) $CL_RED 0.15 | Out-Null
Add-Text $s 68 466 824 18 "Más del 98% del estado es idéntico: guardarlo 200.000 veces es puro desperdicio de memoria." 10.5 (C 254 202 202) $true | Out-Null
Add-Footer $s $slideIndex

Add-Notes $s "Ahora Flyweight. Imaginemos un bosque de 200.000 árboles, pero solo 4 especies. Cada árbol necesita posición, especie, color y textura. Si cada uno guarda su textura de 2 KB, son casi 400 megas solo en texturas, y el 98% de esa información es idéntica. El problema no es la cantidad de árboles: es que estamos repitiendo el mismo estado."

# ============================================================ 10 FLYWEIGHT SOLUCION UML
$s = New-Slide
Add-Header $s "PATRÓN 02  ·  FLYWEIGHT" "La solución: compartir lo intrínseco, pasar lo extrínseco" "Una sola instancia por combinación; la posición vive en el contexto." | Out-Null

Add-Card $s 48 142 864 255 $CL_CARD2 0 0.03 | Out-Null

Add-ClassBox $s 70 225 145 72 "" "Forest" "+ plant(...): Tree" | Out-Null
Add-ClassBox $s 265 210 195 95 "" "Tree" "- x: int`r- y: int`r- type: TreeType" | Out-Null
Add-ClassBox $s 555 175 225 120 "flyweight" "TreeType" "- species: String`r- color: String`r- texture: byte[]`r+ render(x, y)" $CL_ACCENT2 | Out-Null
Add-ClassBox $s 555 320 225 70 "" "TreeFactory" "- cache: Map`r+ getType(...): TreeType" $CL_ACCENT2 | Out-Null

Add-Line $s 215 261 265 261 $CL_ACCENT 1.2 1 0 0 | Out-Null
Add-Diamond $s 221 261 12 | Out-Null
Add-Text $s 222 242 50 14 "1..*" 8 $CL_ACCENT $false "Consolas" | Out-Null

Add-Line $s 460 258 555 230 $CL_ACCENT 1.2 1 0 1 | Out-Null
Add-Text $s 488 226 70 14 "type" 8 $CL_ACCENT $false "Consolas" | Out-Null

Add-Line $s 667 320 667 295 $CL_ACCENT2 1.2 4 0 1 | Out-Null
Add-Text $s 675 300 80 14 "cache" 8 $CL_ACCENT2 $false "Consolas" | Out-Null

Add-Card $s 48 410 420 82 $CL_CARD $CL_ACCENT 0.05 | Out-Null
Add-Text $s 66 422 384 16 "INTRÍNSECO  →  TreeType" 8.5 $CL_ACCENT $true | Out-Null
Add-Text $s 66 444 384 36 "Especie, color y textura. Inmutable y compartido: una instancia por combinación." 9.2 $CL_MUTED | Out-Null

Add-Card $s 492 410 420 82 $CL_CARD $CL_ACCENT2 0.05 | Out-Null
Add-Text $s 510 422 384 16 "EXTRÍNSECO  →  Tree" 8.5 $CL_ACCENT2 $true | Out-Null
Add-Text $s 510 444 384 36 "Posición x, y y una referencia al flyweight. Se aporta en cada operación." 9.2 $CL_MUTED | Out-Null
Add-Footer $s $slideIndex

Add-Notes $s "La solución es separar el estado en dos. Lo intrínseco, lo que se repite, va en TreeType: especie, color y textura, inmutable y compartido. Lo extrínseco, lo único de cada árbol, va en Tree: x, y y una referencia al tipo. La fábrica mantiene un cache por especie y color: la primera vez crea el flyweight, las siguientes lo reutiliza. Así hay 200.000 árboles pero solo 4 texturas."

# ============================================================ 11 FLYWEIGHT CODIGO
$s = New-Slide
Add-Header $s "PATRÓN 02  ·  FLYWEIGHT" "Código y criterios de uso" "La fábrica garantiza una instancia por clave; el contexto aporta lo único." | Out-Null

$flyCode = @'
public final class TreeType {           // flyweight
    private final String species;
    private final String color;
    private final byte[] texture;       // 2 KB, compartida

    public String render(int x, int y) {   // x, y = extrínseco
        return species + " en (" + x + ", " + y + ")";
    }
}

public class TreeFactory {
    private final Map<String, TreeType> cache = new HashMap<>();

    public TreeType get(String species, String color) {
        String key = species + "|" + color;
        return cache.computeIfAbsent(key, k ->
                new TreeType(species, color, loadTexture()));
    }
}
'@
Add-Code $s 48 142 540 355 $flyCode 9.5 | Out-Null

Add-Text $s 612 148 300 14 "CUÁNDO USARLO" 8.5 $CL_ACCENT $true | Out-Null
Add-Bullets $s 612 170 300 104 @(
    "Miles de objetos con estado repetido.",
    "El estado compartido es inmutable.",
    "Pocas combinaciones distintas."
) 9.8 $CL_TEXT 1.22 | Out-Null

Add-Text $s 612 286 300 14 "EN JAVA" 8.5 $CL_ACCENT2 $true | Out-Null
Add-Bullets $s 612 308 300 86 @(
    "String pool de la JVM.",
    "Integer.valueOf(): cache de -128 a 127.",
    "Glyphs de fuentes y sprites de juegos."
) 9.5 $CL_MUTED 1.2 | Out-Null

Add-Card $s 612 398 300 97 (C 35 29 20) $CL_AMBER 0.07 | Out-Null
Add-Text $s 628 410 268 14 "CUIDADO" 8 $CL_AMBER $true | Out-Null
Add-Text $s 628 430 268 54 "Si el flyweight se modifica, todos los contextos cambian. La fábrica debe ser segura entre hilos." 9.3 (C 253 230 138) | Out-Null
Add-Footer $s $slideIndex

Add-Notes $s "El flyweight es final y sus campos son final: inmutabilidad. El constructor es package-private para que solo la fábrica cree instancias. La fábrica usa un mapa con clave especie+color y computeIfAbsent: si existe, lo devuelve; si no, lo crea. El contexto Tree solo guarda x, y y la referencia. Se usa cuando hay miles de objetos con estado repetido, el estado compartido es inmutable y hay pocas combinaciones. En Java ya lo usan el String pool y el cache de Integer."

# ============================================================ 12 TABLA COMPARATIVA
$s = New-Slide
Add-Header $s "CONCLUSIONES" "Los 7 patrones estructurales" "Qué hace cada uno y cuál es la señal para usarlo." | Out-Null

$colX = @(44, 140, 440, 722)
$colW = @(96, 300, 282, 190)
$headers = @("PATRÓN", "QUÉ HACE", "SEÑAL PARA USARLO", "EJEMPLO TÍPICO")

Add-Card $s 44 142 872 34 (C 28 42 68) 0 0.08 | Out-Null
for ($c = 0; $c -lt 4; $c++) {
    Add-Text $s ($colX[$c] + 12) 153 $colW[$c] 14 $headers[$c] 8 $CL_ACCENT $true | Out-Null
}

$tableRows = @(
    @("Adapter", "Adapta una interfaz a otra que el cliente espera.", "Una clase existente no encaja con la interfaz requerida.", "APIs de pago, InputStreamReader"),
    @("Bridge", "Separa abstracción e implementación en dos jerarquías.", "Dos dimensiones cambian de forma independiente.", "JDBC, AWT, codecs"),
    @("Composite", "Compone objetos en estructuras de árbol parte-todo.", "Hojas y grupos se tratan de la misma forma.", "Sistema de archivos, menús"),
    @("Decorator", "Añade responsabilidades envolviendo un objeto.", "Se necesitan combinaciones de features en runtime.", "BufferedReader, filtros HTTP"),
    @("Facade", "Ofrece una interfaz simple sobre un subsistema.", "El cliente no debe conocer muchas clases.", "JdbcTemplate, APIs de arranque"),
    @("Flyweight", "Comparte estado inmutable entre muchos objetos.", "Miles de objetos repiten los mismos datos.", "String pool, sprites"),
    @("Proxy", "Un sustituto controla el acceso a otro objeto.", "Lazy loading, seguridad o caché.", "Hibernate, RMI")
)

for ($r = 0; $r -lt 7; $r++) {
    $y = 176 + ($r * 44)
    $fill = $CL_CARD
    if ($r % 2 -eq 1) { $fill = $CL_CARD2 }
    Add-Card $s 44 $y 872 44 $fill 0 0.03 | Out-Null
    Add-Text $s ($colX[0] + 12) ($y + 13) $colW[0] 18 $tableRows[$r][0] 9.8 $CL_ACCENT $true | Out-Null
    Add-Text $s ($colX[1] + 10) ($y + 8) ($colW[1] - 18) 30 $tableRows[$r][1] 8.7 $CL_TEXT | Out-Null
    Add-Text $s ($colX[2] + 10) ($y + 8) ($colW[2] - 18) 30 $tableRows[$r][2] 8.7 $CL_MUTED | Out-Null
    Add-Text $s ($colX[3] + 10) ($y + 8) ($colW[3] - 18) 30 $tableRows[$r][3] 8.7 $CL_MUTED | Out-Null
}

Add-Text $s 44 488 872 14 "Los tres primeros separan o combinan estructura; los cuatro siguientes añaden, simplifican, comparten o controlan." 8.2 $CL_MUTED | Out-Null
Add-Footer $s $slideIndex

Add-Notes $s "Este es el cuadro comparativo. Léanlo como una tabla de decisión: la segunda columna dice qué hace y la tercera cuándo aparece. Adapter adapta; Bridge separa; Composite arma árboles; Decorator envuelve; Facade simplifica; Flyweight comparte; Proxy controla el acceso. No son excluyentes: un sistema real puede usar varios a la vez."

# ============================================================ 13 GUIA DE ELECCION
$s = New-Slide
Add-Header $s "CONCLUSIONES" "¿Cuál elijo? Guía rápida" "Empieza por la señal del problema, no por el nombre del patrón." | Out-Null

$guide = @(
    @("¿Interfaces incompatibles?", "Adapter", $CL_ACCENT),
    @("¿Dos ejes de cambio?", "Bridge", $CL_ACCENT),
    @("¿Estructura parte-todo?", "Composite", $CL_ACCENT),
    @("¿Sumar comportamiento sin heredar?", "Decorator", $CL_ACCENT),
    @("¿Simplificar un subsistema?", "Facade", $CL_ACCENT2),
    @("¿Demasiados objetos con datos repetidos?", "Flyweight", $CL_ACCENT2),
    @("¿Controlar el acceso a un objeto?", "Proxy", $CL_ACCENT2)
)

for ($i = 0; $i -lt 7; $i++) {
    $col = 0
    $row = $i
    if ($i -ge 4) { $col = 1; $row = $i - 4 }
    $x = 48 + ($col * 440)
    $y = 148 + ($row * 68)
    Add-Card $s $x $y 424 56 $CL_CARD $CL_BORDER 0.07 | Out-Null
    Add-Text $s ($x + 16) ($y + 10) 246 36 $guide[$i][0] 9.5 $CL_MUTED | Out-Null
    Add-Text $s ($x + 258) ($y + 18) 14 16 "→" 10 $CL_BORDER $false "Segoe UI" 2 | Out-Null
    Add-Text $s ($x + 278) ($y + 17) 130 20 $guide[$i][1] 11.5 $guide[$i][2] $true | Out-Null
}

Add-Card $s 488 352 424 56 $CL_CARD2 $CL_ACCENT2 0.07 | Out-Null
Add-Text $s 504 361 392 36 "Se combinan: un Facade puede apoyarse en Singleton; un Composite puede usar Flyweight." 9.2 $CL_MUTED | Out-Null

Add-Card $s 48 428 864 52 $CL_CARD2 0 0.1 | Out-Null
Add-Text $s 68 443 824 22 "Regla práctica: elige por la señal del problema; si no puedes nombrarla, no apliques el patrón." 11 $CL_TEXT | Out-Null
Add-Footer $s $slideIndex

Add-Notes $s "Esta es la guía de bolsillo. Si el problema es de interfaces incompatibles, Adapter. Si hay dos ejes que cambian, Bridge. Si es un árbol parte-todo, Composite. Si quieres sumar comportamiento sin explotar la herencia, Decorator. Si quieres simplificar, Facade. Si el problema es memoria por datos repetidos, Flyweight. Si necesitas controlar el acceso, Proxy. Y se pueden combinar."

# ============================================================ 14 CIERRE
$s = New-Slide
Add-Header $s "CIERRE" "Tres ideas para llevarse" | Out-Null

$ideas = @(
    @("01", "Composición > herencia", "Los estructurales resuelven con objetos y delegación, no creando más subclases."),
    @("02", "Bridge desacopla", "Dos jerarquías que crecen por separado y se conectan con una referencia."),
    @("03", "Flyweight comparte", "Un estado inmutable, miles de contextos: memoria bajo control.")
)
for ($i = 0; $i -lt 3; $i++) {
    $x = 48 + ($i * 296)
    Add-Card $s $x 162 272 178 $CL_CARD $CL_BORDER 0.05 | Out-Null
    Add-Text $s ($x + 20) 178 100 30 $ideas[$i][0] 22 $CL_ACCENT $true | Out-Null
    Add-Text $s ($x + 20) 222 232 22 $ideas[$i][1] 13.5 $CL_TEXT $true | Out-Null
    Add-Text $s ($x + 20) 254 232 70 $ideas[$i][2] 9.5 $CL_MUTED | Out-Null
}

Add-Card $s 48 368 540 104 $CL_CARD2 $CL_BORDER 0.05 | Out-Null
Add-Text $s 68 382 500 14 "CÓDIGO Y PRESENTACIÓN" 8 $CL_ACCENT $true | Out-Null
Add-Text $s 68 402 500 18 "github.com/sebastindiaz123-code/Patrones-Estructurales" 10.5 $CL_TEXT $true "Consolas" | Out-Null
Add-Text $s 68 430 500 28 "bridge/  ·  flyweight/  ·  slides/`rJava 17 + Maven  ·  pruebas unitarias incluidas" 8.8 $CL_MUTED | Out-Null

Add-Text $s 620 366 292 50 "Gracias" 32 $CL_ACCENT $true | Out-Null
Add-Text $s 622 420 292 20 "¿Preguntas?" 12 $CL_MUTED | Out-Null
Add-Footer $s $slideIndex

Add-Notes $s "Para cerrar: composición sobre herencia; Bridge desacopla dos ejes; Flyweight comparte lo inmutable. El código y esta presentación están en el repositorio. Gracias, ¿preguntas?"

# ---------------------------------------------------------------- guardar
$base = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $base) { $base = (Get-Location).Path }
$previewDir = Join-Path $base "preview"
New-Item -ItemType Directory -Force -Path $previewDir | Out-Null

$names = @(
    "01-portada", "02-agenda", "03-que-son-patrones", "04-estructurales",
    "05-para-que-sirven", "06-bridge-problema", "07-bridge-uml", "08-bridge-codigo",
    "09-flyweight-problema", "10-flyweight-uml", "11-flyweight-codigo",
    "12-tabla-comparativa", "13-guia-eleccion", "14-cierre"
)

for ($i = 1; $i -le $pres.Slides.Count; $i++) {
    $png = Join-Path $previewDir ($names[$i - 1] + ".png")
    $pres.Slides.Item($i).Export($png, "PNG", 1600, 900)
}

$pptx = Join-Path $base "Bridge-y-Flyweight-Patrones-Estructurales.pptx"
$pres.SaveAs($pptx, 24)

$pdf = Join-Path $base "Bridge-y-Flyweight-Patrones-Estructurales.pdf"
$pres.SaveAs($pdf, 32)

$pres.Close()
$ppt.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($ppt) | Out-Null
[GC]::Collect()

Write-Output "OK: $pptx"
Write-Output "Slides: $($slideIndex)"
