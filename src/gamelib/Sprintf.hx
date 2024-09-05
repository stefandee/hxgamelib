/**
 * Copyright(C) 2007 Andre Michelle and Joa Ebert
 *
 * PopForge is an ActionScript3 code sandbox developed by Andre Michelle and Joa Ebert
 * http://sandbox.popforge.de
 * 
 * This file is part of PopforgeAS3Audio.
 * 
 * PopforgeAS3Audio is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 * 
 * PopforgeAS3Audio is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */
package gamelib;

	/**
	 * An sprintf implementation in ActionScript 3.
	 * 
	 * <p>
	 * Supported specifiers: <code>cdieEfgGosuxX</code><br/>
	 * Supported flags: <code>+-(space)#0</code><br/>
	 * Supported width: <code>(number); *</code></br>
	 * Supported precision: <code>.(number); .*</code><br/>
	 * Supported length: <code>h</code><br/>
	 * </p>
	 * 
	 * <p>Unsupported parts like length L (long double) will be removed.</p>
	 * 
	 * <p>Each formatter is following the layout <code>%[flags][width][.precision][length]specifier</code>.</p>
	 * 
	 * @param formatString String that containts the text to format.
	 * It can optionally contain embedded format tags that are
	 * substituted by the values specified in subsequent argument(s)
	 * and formatted as requested.
	 * 
	 * The number of arguments following the <code>format</code> parameters should
	 * at least be as much as the number of format tags.
	 * 
	 * The format tags follow C's sprintf() layout.
	 * 
	 * @param args Depending on the format string, the function may expect a sequence of additional arguments, each containing one value to be inserted instead of each %-tag specified in the format parameter, if any.
	 * There should be the same number of these arguments as the number
	 * of %-tags that expect a value.
	 * 
	 * @return The formatted string.
	 * 
	 * @throws Error If the format string is malformed (e.g. containing invalid characters)
	 * 
	 * @see http://www.cplusplus.com/reference/clibrary/cstdio/sprintf.html sprintf on c++.com
	 * @see http://www.ruby-doc.org/doxygen/1.8.2/sprintf_8c-source.html sprintf.c
	 * 
	 * @author Joa Ebert
	 */		

class Sprintf
{
	public static function format( format: String, list : Array<Dynamic> ): String
	{
		var output: String = '';
		var byte: String;
		//var list: Array<Dynamic> = args;
					
		var i: Int = 0;
		var n: Int = format.length;
		var errorStart: Int = 0;
		var p:Dynamic;
		
		while ( i < n )
		{
			byte = format.charAt( i );

			if ( byte == '%' )
			{
				byte = format.charAt( ++i );
				
				if ( byte == '%' )
				{
					output += '%';
				}
				else
				{
					//-- reset locals
					p = null;
					
					//Format: %[flags][width][.precision][length]specifier  
					
					//-- flags
					var flagJustifyLeft	: Bool = false;
					var flagSignForce	: Bool = false;
					var flagSignSpace	: Bool = false;
					var flagExtended	: Bool = false;
					var flagPadZero		: Bool = false;
					
					while (
							byte == '-'
						||	byte == '+'
						||	byte == ' '
						||  byte == '#'
						||	byte == '0'
					)
					{
						     if ( byte == '-' ) flagJustifyLeft	= true;
						else if ( byte == '+' ) flagSignForce	= true;
						else if ( byte == ' ' ) flagSignSpace	= true;
						else if ( byte == '#' ) flagExtended	= true;
						else if ( byte == '0' ) flagPadZero		= true;

						byte = format.charAt( ++i );
					}
					
					//-- width
					var widthFromArgument: Bool = false;
					var widthString: String = '';
					
					if ( byte == '*' )
					{
						widthFromArgument = true;
						byte = format.charAt( ++i );
					}
					else
					{
						while (
								byte == '1' || byte == '2'
							||	byte == '3' || byte == '4'
							||	byte == '5' || byte == '6'
							||	byte == '7' || byte == '8'
							||	byte == '9' || byte == '0'
						)
						{
							widthString += byte;
							byte = format.charAt( ++i );
						}
					}
					
					//-- precision
					var precisionFromArgument: Bool = false;
					var precisionString: String = '';
					
					if ( byte == '.' )
					{
						byte = format.charAt( ++i );
						
						if ( byte == '*' )
						{
							precisionFromArgument = true;
							byte = format.charAt( ++i );
						}
						else
						{
							while (
									byte == '1' || byte == '2'
								||	byte == '3' || byte == '4'
								||	byte == '5' || byte == '6'
								||	byte == '7' || byte == '8'
								||	byte == '9' || byte == '0'
							)
							{
								precisionString += byte;
								byte = format.charAt( ++i );
							}
						}
					}
					
					//-- length
					var lenh: Bool = false;
					var lenl: Bool = false;
					var lenL: Bool = false;
					
					while (
							byte == 'h'
						||	byte == 'l'
						||	byte == 'L'
					)
					{
						     if ( byte == 'h' ) lenh = true;
						else if ( byte == 'l' ) lenl = true;
						else if ( byte == 'L' ) lenL = true;
						
						byte = format.charAt( ++i );
					}
					
					//-- specifier
					var value: String = "";
					var width: Int = Std.parseInt( widthString );

          p = precisionString;
					var precision: Int = Std.parseInt(p);

					var padChar: String = ( flagPadZero ) ? '0' : ' ';
					
					if ( precisionFromArgument )
					{
						p = list.shift();
            precision = cast(p, Int);
					}
						
					if ( widthFromArgument )
					{
						width = cast( list.shift(), Int );
					}

					switch ( byte )
					{
						case "c":
            {
							value = String.fromCharCode( cast( list.shift(), Int ) & 0xff );
								
							if ( width != 0 )
							{
								value = pad( value, width, flagJustifyLeft, padChar );
							}
            }
							
						case "d", "i", "o":
            {

              var intValue: Int = cast( list.shift(), Int );

							if ( lenh ) intValue &= 0xffff;
							
							if ( byte == 'o' )
							{
								value = "" + Std.parseInt("0" + intValue);/*intValue.toString( 8 );*/
							}
							else
							{
								value = Std.string(intValue);/*intValue.toString();*/
							}
							
							if ( precision != 0 )
							{
								value = pad( value, precision, false, '0' );
							}
							
							if ( intValue > 0 )
							{
								if ( flagSignForce )
								{
									value = '+' + value;
								}
								else
								if ( flagSignSpace )
								{
									value = ' ' + value;
								}
							}
							
							if ( flagExtended && intValue != 0 && byte == 'o' )
							{
								value = '0' + value;
							}
								
							if ( width != 0 )
							{
								value = pad( value, width, flagJustifyLeft, padChar );
							}
							
							if ( intValue == 0 )
							{	
								if ( p != null /*&& p != undefined*/ && p != '' )
								{
									if ( precision == 0 )
									{
										value = '';
									}
								}
							}
            }
							
						case "u","x","X":
            {
							#if neko
              var uintValue: Int = cast( list.shift(), Int );
              #else
              var uintValue: UInt = cast( list.shift(), UInt );
              #end
							
							if ( lenh ) uintValue &= 0xffff;
							
							p = precisionString;
							
							if ( byte == 'x' )
							{
								value = gamelib.Utils.hex(uintValue).toLowerCase();//StringTools.hex(uintValue).toLowerCase();//uintValue.toString( 16 );
							}
							else
							if ( byte == 'X' )
							{
								value = gamelib.Utils.hex(uintValue).toUpperCase();//uintValue.toString( 16 ).toUpperCase();
							}
							else
							{
								value = Std.string(uintValue);//uintValue.toString();
							}
							
							if ( precision != 0 )
							{
								value = pad( value, precision, false, '0' );
							}
							
							if ( uintValue > 0 )
							{
								if ( flagSignForce )
									value = '+' + value;
								else if ( flagSignSpace )
									value = ' ' + value;
							}
							
							if ( uintValue != 0 )
							{
								if ( flagExtended )
								{
									if ( byte == 'x' )
									{
										value = '0x' + value;
									}
									else if ( byte == 'X' )
									{
										value = '0X' + value;
									}
								}
							}
								
							if ( width != 0 )
							{
								value = pad( value, width, flagJustifyLeft, padChar );
							}
							
							if ( uintValue == 0 )
							{	
								if ( p != null /*&& p != undefined*/ && p != '' )
								{
									if ( precision == 0 )
									{
										value = '';
									}
								}
							}
            }
							
						case "e","E":
            {
							var sciVal: Float = cast( list.shift(), Float );

							if ( precision != 0 )
							{
#if flash9
								value = untyped sciVal.toExponential(Math.min( precision, 20 ));
#else
                // TODO: find some code to transform from float to exponential form
                value = Std.string(sciVal);
#end 
							}
							else
							{
#if flash9
								value = untyped sciVal.toExponential(6);
#else
                // TODO: find some code to transform from float to exponential form
                value = Std.string(sciVal);
#end 
							}

							if ( flagExtended )
							{
								if ( value.indexOf( '.' ) == -1 )
								{
									value = value.substr( 0, value.indexOf( 'e' ) ) + '.000000' + value.substr( value.indexOf( 'e' ) + 1 );
								}
							}
															
							if ( byte == 'E' )
								value = value.toUpperCase();
								
							if ( width != 0 )
							{
								value = pad( value, width, flagJustifyLeft, padChar );
							}
            }
							
						case "f":
            {
							var floatValue: Float = cast( list.shift(), Float );
							
							if ( precision != 0 )
							{
								value = Std.string(floatValue);//floatValue.toPrecision( precision );
							}
							else
							{
								value = Std.string(floatValue);//floatValue.toPrecision( 6 );
							}
							
							if ( flagExtended )
							{
								if ( value.indexOf( '.' ) == -1 )
								{
									value += '.000000';
								}
							}
								
							if ( width != 0 )
							{
								value = pad( value, width, flagJustifyLeft, padChar );
							}
            }
							
						case "g","G":
            {
							var flags: String = '';
							var precs: String = '';
							var len: String = '';
							
							if ( flagJustifyLeft ) flags += '-';
							if ( flagSignForce ) flags += '+';
							if ( flagSignSpace ) flags += ' ';
							if ( flagExtended ) flags += '#';
							if ( flagPadZero ) flags += '0';
					
							if ( p != null/* && p != undefined */&& p != '' )
							{
								precs = '.' + Std.string(precision);
							}
							
							if ( lenh ) len += 'h';
							if ( lenl ) len += 'l';
							if ( lenL ) len += 'L';
							
							var compValue: Float = cast( list.shift(), Float );
							
							var v0: String = Sprintf.format( '%' + flags + precs + len + 'f', [compValue] );
							var v1: String = Sprintf.format( '%' + flags + precs + len + ( ( byte == 'G' ) ? 'E' : 'e' ), [compValue] );
							
							value = ( v0.length < v1.length ) ? v0 : v1;
            }
							
						case "s":
            {
              var tmp = list.shift();

							value = cast(tmp , String );

							
							if ( precision != 0 )
							{
								value = value.substr( 0, precision );
							}
								
							if ( width != 0 )
							{
								value = pad( value, width, flagJustifyLeft, padChar );
							}
            }
						
						case "p","n":
            {
            }
							
						default:
							throw  'Malformed format string "' + format + '" at "'
								+ format.substr( errorStart, i + 1 ) + '"';						
					}
					
					output += value;
				}
			}
			else
			{
				output += byte;
			}
				
			errorStart = ++i;
		}
		
		return output;
	}

  private static function pad( string: String, length: Int, padRight: Bool, char: String ): String
  {
    var i: Int = string.length;
    
    if ( padRight )
    {
      while ( i++ < length )
      {
        string += char;
      }
    }
    else
    {
      while ( i++ < length )
      {
        string = char + string;
      }
    }
    
    return string;
  }
}