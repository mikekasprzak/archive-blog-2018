---
id: 7059
title: PHP Mad Notebook
date: 2014-10-21T00:51:55+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=7059
permalink: /2014/10/21/php-mad-notebook/
categories:
  - Technobabble
---
This isn&#8217;t a blog. It&#8217;s a notebook.

## APCu Functions

Arguments in []&#8217;s are optional. Cross reference with [APC docs](http://php.net/manual/en/book.apc.php). [PECL Page](http://pecl.php.net/package/APCu). [Github](https://github.com/krakjoe/apcu).

<pre>function apcu_cache_info([$type [, $limited]]);
function apcu_clear_cache([$cache]);
function apcu_sma_info([$limited]);
function apcu_key_info($key);
function apcu_enabled();
function apcu_store($key, $var [, $ttl]);
function apcu_fetch($key [, &$success]);
function apcu_delete($keys);
function apcu_add($key, $var [, $ttl]);
function apcu_inc($key [, $step [, &$success]]);
function apcu_dec($key [, $step [, &$success]]);
function apcu_cas($key, $old, $new);
function apcu_exists($keys);
function apcu_bin_dump([$user_vars]);
function apcu_bin_load($data [, $flags]);
function apcu_bin_dumpfile($user_vars, $filename [, $flags [, $context]]);
function apcu_bin_loadfile($filename [, $context [, $flags]]);
</pre>

Iterator functions are omitted, but also available. 

The above is a cleaned up version of what&#8217;s output by `"php --re apcu"`.

## Perl-like ?: Operator

<pre>$a = TRUE ?: FALSE;       // true
$b = FALSE ?: TRUE;       // true
$c = NULL ?: "DeathRope"; // "DeathRope"
</pre>

From [Tips](http://ilia.ws/files/zendcon_2010_hidden_features.pdf).

## Data Format: Raw PHP variables (var_export)

To serialize something to disk in the fastest way PHP can read it, you make it source code by calling var_export. Whenever the file changes, it should cause a cache miss with OPcache.

<pre>mixed var_export ( mixed $expression [, bool $return = false ] );

$php_array = Array( 2,5,6,14 );
$export = var_export($php_array, true); // true = return the value (else echo)
file_put_contents('export.php', '<?php $php_array = ' . $export . '; ?>');</pre>

To use it:

<pre>include 'export.php';</pre>

Alternatively, if you store it a different way:

<pre>eval( $php_array );</pre>

But this will cause OPcache to miss every time.

## Data Format: JSON (decode, encode)

Apparently this is the fastest encoder, as of PHP 5.3. [Benchmarks](http://stackoverflow.com/questions/804045/preferred-method-to-store-php-arrays-json-encode-vs-serialize).

<pre>mixed json_decode ( string $json [, bool $assoc = false 
    [, int $depth = 512 [, int $options = 0 ]]] );

string json_encode ( mixed $value [, int $options = 0 [, int $depth = 512 ]] );

int json_last_error ( void );

$json_in = '{ "money":200, "love":false }'; // json uses "", not ''
$array_out = json_decode( $json_in, true ); // true = output an array (else object)
$json_out = json_encode( $array_out );

var_dump( $array_out );
// array(2) { ["money"]=> int(200) ["love"]=> bool(false) }
var_dump( $json_out );
// string(26) "{"money":200,"love":false}"
</pre>

[json_decode](http://us2.php.net/manual/en/function.json-decode.php), [json_encode](http://us2.php.net/manual/en/function.json-encode.php), [json\_last\_error](http://us2.php.net/manual/en/function.json-last-error.php)

## Data Format: Serialize, Unserialize

A faster decoder (slower encoder), and types/classes persist.

<pre>string serialize ( mixed $value );
mixed unserialize ( string $str );

$data = Array( 'fox'=>true, 'zippy'=>13 );
$out = serialize( $data );
$new_data = unserialize( $out );

var_dump( $out );
// string(37) "a:2:{s:3:"fox";b:1;s:5:"zippy";i:13;}"
var_dump( $new_data );
// array(2) { ["fox"]=> bool(true) ["zippy"]=> int(13) }</pre>

[serialize](http://us2.php.net/manual/en/function.serialize.php), [unserialize](http://us2.php.net/manual/en/function.unserialize.php)

## Data Format: IGbinary

An alternative, external binary encoder/decoder. According to [benchmarks](http://stackoverflow.com/a/4820537), the fastest.

<https://github.com/igbinary/igbinary> ([PECL](http://pecl.php.net/package/igbinary))

<pre>// Drop in replacement for serialize/unserialize //
string igbinary_serialize ( mixed $value );
mixed igbinary_unserialize ( string $str );

$data = Array( 'fox'=>true, 'zippy'=>13 );
$out = igbinary_serialize( $data );
$new_data = igbinary_unserialize( $out );

// TODO: VarDump
</pre>

Smaller too.

Tips and Tricks:[http://ilia.ws/files/zendcon\_2010\_hidden_features.pdf](http://ilia.ws/files/zendcon_2010_hidden_features.pdf)

## Data Format: CSV

Reading Only.

<http://php.net/manual/en/function.str-getcsv.php>

<pre>array str_getcsv ( string $input [, string $delimiter = "," 
    [, string $enclosure = '"' [, string $escape = "\\" ]]] )

$arr = str_getcsv($data);

// TODO: output
</pre>

## Data Format: XML

Reading Only (there is writing, but it seems more difficult).

<pre>SimpleXMLElement simplexml_load_file ( string $filename 
    [, string $class_name = "SimpleXMLElement" 
    [, int $options = 0 [, string $ns = "" 
    [, bool $is_prefix = false ]]]] )

SimpleXMLElement simplexml_load_string ( string $data 
    [, string $class_name = "SimpleXMLElement" 
    [, int $options = 0 [, string $ns = "" 
    [, bool $is_prefix = false ]]]] )

$string = "&lt;thing>It Happened&lt;/thing>";
$xml = simplexml_load_string( $string );

// TODO: Output
</pre>

If you prefer Array format (like me), here&#8217;s a function.

<pre>// http://upskill.co.in/content/how-convert-simplexml-object-array-php
function __xml2array($xml) {
	$arr = array();

	foreach ($xml->children() as $r) {
		$t = array();

		if (count($r->children()) == 0) {
			$arr[$r->getName()] = strval($r);
		}
		else {
			$arr[$r->getName()][] = __xml2array($r);
		} 
	}
	return $arr;
}
</pre>

Then simply 

<pre>$string = "&lt;thing>It Happened&lt;/thing>";
$xml = simplexml_load_string( $string );
$array = __xml2array($xml);
</pre>

## Data Format: HTML

Use Simple HTML DOM parser.

<http://simplehtmldom.sourceforge.net/> ([Manual](http://simplehtmldom.sourceforge.net/manual.htm))

<pre>// $html = file_get_html('http://www.google.com/');
// $html = str_get_html('

<div id="hello">
  Hello
</div>

<div id="world">
  World
</div>');

$text = '

<div id="me" class="president">
  cant touch this
</div>';
$html = str_get_html( $text );

// TODO: Output
</pre>

## Data Format: String Delimiter

<pre>array explode ( string $delimiter , string $string [, int $limit ] );
string implode ( string $glue , array $pieces )

$in_data = "Frank|Donald|Scott|Wrenchy";
$out = explode("|",$in_data);
$csv = implode(",",$out);

var_dump( $out );
// array(4) { 
//  [0]=> string(5) "Frank" 
//  [1]=> string(6) "Donald" 
//  [2]=> string(5) "Scott" 
//  [3]=> string(7) "Wrenchy"
// } 
var_dump( $csv );
// string(26) "Frank,Donald,Scott,Wrenchy"
</pre>

[explode](http://ca2.php.net/manual/en/function.explode.php), [implode](http://ca2.php.net/manual/en/function.implode.php)

## [unset](http://us2.php.net/manual/en/function.unset.php)

<pre>$myvar = "hello";
unset( $myvar ); // Deleted. See documentation for notes on Globals and references</pre>

## [val and type juggling](http://php.net/manual/en/language.types.type-juggling.php)

<pre>echo boolval(2);                 // true
echo intval("14") + 1;           // 15
echo floatval("12.5") * 2;       // 25 (NOTE: doubleval is an alias for floatval)
echo strval(true);               // "true"
echo settype("5bars","integer"); // 5 (explicit casting)
echo (boolean)10;                // true (typecasting)
</pre>