﻿package flash.view.keyboard  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.widget.Button;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;
	import flash.utils.Base64;
	import flash.utils.getQualifiedClassName;
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.utils.AttributeSet;
	
	public class Key extends Button
	{
		public static const shift_ico_up:ByteArray = Base64.decode("Q1dTD5gFAAB4nKWUz27TMACH3UnsAgcQmrSj6Y4jdZyuXRu11UrSSD1UoK2Cwc1N3DVaEkd2+k9CYuLAhVPvvALSJBDSkIBXyM7ceACeASdtt24dYxqHJHL0/T47P1vZB69A5jEA6xlgPlgHALx5eP8OABXudPVd04Ij3wuELkfVbC+KQh2h4XCYG+ZzjB8gXC6XkaohTVMkoYhxEJGREoiNbA2mBpMKm7th5LIAJmPSYf2oms3OtCM/PNMGIkcc1qE5m/loREKEcypKPBLSDU5JxHibMa9WTyhoeUT04DPOulQIqSceNPaKUIGdvus5cKuEK+hycsFFTXnVNBUXFLWgaLiNsY41Hec31byuqgvZKTmNtmhEHBKRpXBRV2W4vBi+wM7izHG74xuFz0lYQZeavFm3jn1WbdjnXrpfjo2oR30aRELWi9N6HVvvMu6TqEbC0HNtkgjRSBE9Zh8OyYAq3aTqCjoHb7sk+WWt1vUb7vtoTotol3avp0V7HFK0SwXrc5tKfGN2YFotuRbuDqhjceanawkJFzThq9l5IIHTWXQ3EBEJbNo0azKdc11HLxhWqVA31Ccly2psYVxX63VTK+etkrldMPJGBS1F5zaH2f2k5JnNkbbtorZd10yr1LjethCd2xh3D1x5vs3bW69QwPSgXezpvLvlqQrmv+pYis5tzSvKvaGtuVju9NXT/6njr4orjzSa/QRrEBgr8tf4Y+2RvGdA/CH+Hn87fRsfx1/k8318AuOvcvD59AhiiYHNFNtffbnTyh6tACEEmEwmAK717n36+fH3XWPw4iT/67j9+nljj3PwbnU1I3mwI2N/AOityvk=");
		public static const shift_ico_down:ByteArray = Base64.decode("Q1dTD6AFAAB4nKWUT0/UQBjGZ41w8qAxJBzHclGxnU4L7G6zNGy2NOGwUZADehvaWbah7TQzXXY5STx48ROY6MGjNxM3JmjUr1AunvwSnjzitOzCwgJBTPon0zzP7337zJvZAM9B6REA0yXg3JkGALy4e3sCgBr3W9aa48JeFMbCkqtFpZ2miYVQt9vVuqbG+BbC1WoV6QYyDFUqVLEbp6SnxmJGsWFBcKjweJCkAYthviabrJMuKsoA24uSY2wsNOKzTap5LEI9kiCs6SjnSJHV4JSkjK8zFtr1XAXdkIg2fMJZiwoh8SSEjacLUIWbnSD04VwF19BZ5wiLOvK2DR3Pq/q8auB1jC1sWNic1U1L10e8R8oja5OmxCcpGTMblimvyqj5lHZgZ37Q2r2S+UQJa+hMklfL1veOo006PCz2y/cQDWlE41TIeHERr+9ZLcYjktokScLAIzkQ9VTRZt52l+xQtZVHXUMnwuu2JP+s2bx8w6MIDdUiXaOty9VifTehaI0K1uEelfKZwcA0m7IXHuxQ3+UsKnpJCBc01y8qQ0MuLqpYQSxSEnt0xbGlWwsC3yovGOW64biVZdddnsO4rtfrjlE13YpTnm+YjRoasw5pPvM6ecgDmv8PtBHrkMZ4sBXI+XauTz0HAYtBO53TSXbjpZbLjmk6dbeKLyo1Zh3SVsbDvSptZTTco0+P/yeOCxHnjjQaHII2BI0b8mj8MXVPPksge5t9z74dvMw+Zp/l+3W2D7MvctE/2INYyoBZyDYmny01lb2b4PDwEPT7ffDgvgZWV1eBPtW+9endzz8T77/O/nrze+OhPat82K+CV5OTJekDS9L+F4WYzt4=");
		public static const backspace_ico:ByteArray = Base64.decode("Q1dTD9UFAAB4nKWUy2sTQRzHJ4I9V0qhoIc1vbVuZme3SZNtGl2yWSgSlJhiEUSmu5Nm7b7Y3TxqBUXBg54VfIB4EguCh1q0Rf0D7CFF25Og4EmK9x7EOJtHmz6spR72Mcv3+/n99js/ZgJcAqFTAPSFgHysDwBwo6f7KABJVyuIOVlhqqZheSJdjYaLvu+IEFYqlUhFiNjuFESJRAJyPOR5lipYb8bycZW1vP5wimkQZOKpru74um0xwRpP2iV/NBxuYaums4m1vAjW7EkSUW0TVrEDUYSDAYeKxLRLsG+7eds2UlKgYhQDe0XmvGsXiOdRPDaY9IUYwzKTJd3QmKE4SsKdzg4WkemV4jkUZbkoy6M8QiLiRSQMcoLIcR3eprJpzRIfa9jHO808LwoxEcU7zdu0Lbut6YWZA5m3lEwS7kjyYNlq6ma0Tsk1GvulqZAYxCSW79F4USNeTRULtmtiP4Udx9BVHABhlfWKtjpdwWXCFoKok3BLeNiW6J9ls/tvuGnCttrzc6Swv9rLzzgE5ohnl1yVUHl/a2CyWdqLq5eJpri22ejFwa5HAv1ouG0IxI0qom55PrZUMianqDui65oYTcQkhBQ5oyhKZgihRFqS07yQEXiUiXKZoSTcZW3TNFstBSG3aBqlDcf4YYmXlXimSZM4SZL5hKDE5eFoWki3aR3WNs129Smdzrd8eOoeCKYxaNtz2spud6mo9K84dlnbtLE9wj0gbawz3Oanc/8Tx18Re440bB2CKQakj9Cj8UPvSXoPgdqT2vvau5VbtVe1Bfq8V3vL1BbpYn7lJoOoDBQbsonQxW/PTtCXer0Ounuv/lI28i+kpc+5yxnt+rfF8pfZj7dfLj1eLz00vp69cm3x6cDI89n10ve7p+vLyz2/34i1jbWF1bmf+fFPI8enB8trAz8emHP3Z6cH5l/HVsfNudVHExq409UVojXAGVrzD9AH8lI=");		
		public static const ctrl_ru_ico:ByteArray = Base64.decode("Q1dTD3sHAAB4nEtgUG1g0FjAIMHI4CIowcDAUC8swMrAYFOUkmYV5OKmUJGbk1dsBeTZKmWUlBRY6euXl5frlRvr5Rel6xtaWlrqGxjpGxnpAlXoFlfmlSRW6OYVKyvZKYBNcEktTi7KLCjJzM9TAPETk/JLS2yVlKDGVuQWwI3NK9ZLTMlPStVLzs/Vr0gs0DfUM9AHmQNUZOVclJpYkl8Ukp+fY+cIUqXglpNYnKEQUJSfllpcDDQ+MUfBOdhMQVchqTQzJ0XBxMLQRh9dJ5JZqS5AbGdkYGiqa2Cqa2QYYmhoZWhkZWisbWBsZWCApBeiEqLVN7UkMSWxJBFVs0kISI+ZlYElsmYUtVDt+SmZaZVEaUaoVLDRRwtJ4sI2JRketAWlRTng+EpJ1k/NSc1NzSspBgavITh4U5Kt0vKLchNL7BILCnIykxNBBupX6BZn5CdnlyeWpeqmgYLaRh+hkFwnAX3m64s/wnNz9WGqi0uCUtPwqy4OqSxI1Q9KLc4vLUpOBSpXhiYYX1+gW4oyy1JT3Iryc8FuKUgsKk4FqbdVgmkAKQbbYpWZV1ySmJec6uliB9Stl5mZYmVg7uxmZmZpYulkYOhqamjoaOTsamFo4WpiZGlk4QKKKAytMNNS8pNLQYEMNS0FaJq5mZG5o5GLm4Wrm5urCdA0A0dHFyNLYzcLF3NTZ2NnmGlIWmGm5RdlpmcC07cL+aZiMUIBnNBQwwkRdphWmRlbGhtZuro6muMKDgytMNM8MQOXWNM8kQMXIuRPSXDgNAJrktaHFoJ2CgzOTMCicb8oG5BkZCgqBbIZNJlA7Ljj6uY/GRsYGebOnc8gwOs25+tMXhXR5iS1/NfvdWbK7j1VuHaqhqh00Z5fubZ/GDuLDTvTuliXhpxePT2a72zM+n8fm54sOcCn8eoGH3evrrpir+a0a7KOhnJKRyK6FQ1FXggw5nsu+f1hz8mtCYKVls1nGFm9ffsuhFh7F709uD1lvYdh7HRpuaCgXvXs2+7yB1bEzNo6OVHn0yTHd7fTdDnVHQ/t0HjF+OZ7anDiv/iLu/ymRUY0HPeW/+s7LbtCc63LHP0tWZ9ce2JjtOeuOR5n0+gh17zhv/63OjFvdR/52+YOSz0db5TP/lqsKG6zsuF1d1xgccMxVr7ttysvfIjcFvClaXvWpd0sZ3a8cuJjL9Xd/lbNX/TMT2O7TaYnhdeJ15Z/PjnPLl5/zwONvFumsnnLvjYlKmTMiWkXOSFkwLj7pV1twvJ3N7bK8q2Ly1zqzlrve2XOJvvA22uWvNHj2n6yOG5b1PP7x0pWrza7vZ7rjohorVndqWVHZBYs7pmvbdTPyLR6uuONzCncG3u+nvRven5I7czuv8tZZQ0+HWbVObJ35f/ZG35v6uGyyiwPLc749e5ewu7K96mpC88/CE5+9lbS6Vpjz6bSS8vni59b/Tq0RTTmpsyBLcfNq+5qzD5x+yd7UkLJB5k3XQJZkyQW8JxiZHu06a12htn0G9day7bkmel9vdaqt/ruH/fu+7uSPxvN1peauCNPt33tioQHqzf5KrMUVnysrI7N/zXlW1Cp6OvMT6Yl13tusBxoY2NjBKYWBgdgAgIARP+3TQ==");
		public static const ctrl_en_ico:ByteArray = Base64.decode("Q1dTDyAHAAB4nEtgUG1g0FjAIMHI4CIowcDAUC8swMrAYFOUkmYV5OKmUJGbk1dsBeTZKmWUlBRY6euXl5frlRvr5Rel6xtaWlrqGxjpGxnpAlXoFlfmlSRW6OYVKyvZKYBNcEktTi7KLCjJzM9TAPETk/JLS2yVlKDGVuQWwI3NK9ZLTMlPStVLzs/Vr0gs0DfUM9AHmQNUZOVclJpYkl8Ukp+fY+cIUqXglpNYnKEQUJSfllpcDDQ+MUfBOdhMQVchqTQzJ0XBxMLQRh9dJ5JZqS5AbGdkYGiqa2Cqa2QYYmhoZWhkZWisbWBsZWCApBeiEqLVN7UkMSWxJBFVs0kISI85mmYUtVDt+SmZaZVEaUaoVLDRRwtJ4sI2JRketAWlRTng+EpJ1k/NSc1NzSspBgavITh4U5Kt0vKLchNL7BILCnIykxNBBupX6BZn5CdnlyeWpeqmgYLaRh+hkFwnAX3m64s/wnNz9WGqi0uCUtPwqy4OqSxI1Q9KLc4vLUpOBSpXhiYYX1+gW4oyy1JT3Iryc8FuKUgsKk4FqbdVgmkAKQbbYpWZV1ySmJec6uliB9Stl5mZAowTZzczM0sTSycDQ1dTQ0NHI2dXC0MLVxMjSyMLF1BEYWiFmZaSn1wKCmSoaSlA08zNjMwdjVzcLFzd3FxNgKYZODq6GFkau1m4mJs6GzvDTEPSCjMtvygzPROYvl3INxWLEQrghIYaToiww7TKzMTS2MjS1dXRHFdwYGiFmeaJGbjEmuaJHLgQIX9KggOnEViTtD60ELRTYHBmAhaN+0XZgCQjQ2oekM1wjhHEDu2bc8D/AyPD3LnzGQRE49+wHile4MC66JzJhjWnsx34b+h5+TC8TlvdXvKo51fQ0z+MnZt1O9O6/yxdcXzbnA2Hf9TLbY4NY3B/8ozfgCeo1c+0QGZ5pN+z6DVlv89EvDqp0R29VLhSul7hjY8Pt09xGdfmyn2hV2fnXm/N414frVv8/rGFyHGb4rTYf5ffmJxivXGs6snyg8UPGZYVfry2nu3iFN0MidPqsVqVH2te7ZNldd5zuP9l2YPbm8KXSKw73duvqek2eevbRVw9t6SlbgYtc/ZkTbjROfvX79Nq7vlFE0L0fHfobcpRXRDkYHs75+hClRcWISILl/wWsDadtOfX9ZjFkkwlXDsrt4UUhH+563la+avsrlN+hx6srlqfmhb4QHeqb4elo7ukTQnz0U37We7sWaTFOHsj86YeK6ukl4lN05Lirvw/e6P2phur0IPble9TUxeef3s15pbd7u0zNDRi2Gan8ntol63V3uBz+u1z54OOzjvmXVx9UsywtGBd2WbZik+zda59CI7qtIgRWamxm+9z3boUpedTDWQLs0/pFUgcXvG3fq7H7Y9TYq/eW7JPujvw2OdV/8uaV9xulWONF1LcmXbT4Y5H1oY7O3KW52mYRuR57sjTPbZsNQNDGxsbIzBKGRyAsQwAI/SN+A==");
		public static const esc_ico:ByteArray = Base64.decode("Q1dTD6MGAAB4nKWUT2gUVxzH36aNFqHWUgNSKj42NXYxs29m9u8MyZLNzq4kssRsdiOVBDOZeWsm7uwMM7N/Usp2aUFPFQ9JaBGpaGObpO2lBqGWai89CD0o5mDAo9CiUunFtlTSN7O7ZmNUgj3MwO/N9/t5v/d9P2YM7K2C986BXS4gvLkLAPDRWztaAegy5CyfEhKwrObyJk+qbveEZek8QqVSyVvyeTXjGGI4jkM0i1iWIgrKnMpbYpnKm+3uCHQIAjYlQ9EtRctDuxbHtYLV7XbXsWVVf4LNm15R1saxV9JUVBZ1xHhpZHOIiI8ZWLQ0I61puUjUVsFETjQn4CFDy2LTJHgxB2NDQUjB8YKSk6E/zHShp51NLCyQJ8LSTICiAxTLpBmGZ1ie8e2nfTxNN3lrypo1iS1RFi1xvdmfdjy8P9RsXqet2zVZyU5tyrymhF3oqSQ3l60sPYlWLxg5575kCeEcVnHeMkm8jBOvLPFZzVBFKyLqek6RRBuIypQ5oUnHS2IRU1k76i60JnzZlsjJkskXX7iqoobatFI4+2K1mZ7SMUphUysYEiby9vrAJJOkF0MpYjlhaKrTiy4aJrb13e6GwRY7u/BK3rTEvIT7hAhxexVF5ulQLBEMcn6ul2biAYaJsrF4mAnH/SzHhgX7ojZYGzRZkwp2yHWaTGihIBuKskIiHE8k4n5Co6NRgeV8ibAQCsR8sQatydqgaYZyTCHzLbw89RkI6Aza+pzWstu4VZDmfCwXj0dDz4tjg7VB69sY7mZpfc3h1pYG/k8cz0U8c6RR/ScYgSDWQn6NV9u2krcLEBEpwCGXXWRG5kcnelrA2bNfgNXVVQDbOjtfWbiSmv2Wil+b82SX576+kinOwVTl+8lBUlzN6J7dY4HDTvHjzlPfrEwXlEm0PLJtz08l+MGl0p4fFn/uH5ohrsocdQR++bi6PDp/YHj2/MP0x/rbi0ueyZu3RradTp5xtlhZPJk6OtNx70TPO6e3H1x6d8zVcb/S025tF5LtVfDb78crB4ZPnX+Q+Wf6ZGpf4au9K7OvgTcejbDVD//d6u6Y+QvsuCz9Wf3kVeDp3WfdGb7ddlu68Wksef2P3jOXzxkXLg5Ud2dqHbYe/uXXxYODlYUH/fDiwPXlo/M2+eHQ39cmv7t1gXwpe+6+v2QfZXRe2Hm/c2WaFF5yLvWz1zO1otV3L+j0vORp+fzR/sHiwuP+I5eiQluxvgpObNniIqGCHhL0fxvmRBs=");
		public static const ru_ico:ByteArray = Base64.decode("Q1dTD9MGAAB4nKWUfUwTZxzHn2NKGGSZhHUzhmSXlugSaO+l7dHeoFnt9TLMqobVuJAMfbi7wuH1rrm7SknYJPyxN8Ep4jJAnCNUHGaOZS9kbMu2LDFucxuUmWimyeaMiVNnINC51+xaWimihrg/7pLnl+/38zzP9/fL8wzY2o60AbAaAUzxagDArpJVKwGoUvkQXcuwaCwsyRptrKrNTboeoTGspaXF1mK3KWojRrjdbgwnMZK0Ggqr1irrMGaVNYvZg6YJjKBxqhjRRUVGU2vYoET1arM5g42FIzexsmaDvNIg2DgljMVgBCNsOJbiGCLapwpQV9Sgokgeb0qFshLUmtDNqhISNM3AQwn1PU2hVrQhKko86nARVditzhyWwBifh8QJpxV3WkkiSBA0QdKEvRy30zie451XzlsDgg55qMPFZkcQJ2m7k3ZQueZF2oxd4cVQ67LMC0q0CrslyeVly3M3o41EVSndL57DBEkIC7KuGfES6Xh5jg4pahjqHhiJSCIHU0AsZtWaFG5HC9wpWEOpqKuwBeG9Hsm4WSBw94aHw1hWrem1Qujuai3YGhGwWkFToionGHJLZmACAeMsqrhT4FlVCafPEoGqJqT01easISVO70KLsqZDmRNqGI/htokiT+OVPpai3A73epzwOwnCS/r8LsLld5Bu0sWkGrXEmqXxChdNhZyh8QatkiIrvSTDuvws63cYNNzrZUi3nXUxlU6f3Zel5VizNEUVG0Vjvpl7p94GgaYHbXFOC9kt3YryeknKSVFex53iWGLN0mqWhrtcWk1uuPOlTf8njjsibjvSWOYR9KDAl2c8jZ+Ziow/AtSo8eRA2SiANiRVCB49PTuEImBg4A2w6qGrsj74W9+XUx+My78+Bc58RVXk80j37r3dE/dtOHhyEwLjmy9OS537LRV5Ne0n/sA/KeDzvphOxOn6S37gOFzb87d4vnSWebGgefyb4Ynh+n735dLZS8feLkxCh+n0joFzCaFuwxitxR+cKfGXvvI9FH8Gwe4/P8b6TFcnwyfqJ4ZDJd5nD1wbDtYVdcTfe/e7ROMura91z6vXxy3j5oILRRce/2Xy1PMabiqvP/51cmrEujK5zVF+dvDHzk/f3HhqbcfhkeZ/5h4+Obpieo18P1t4vfjKI8m+f394a+SGact5z4GXEs3Fvdulduu+mZlHpfx4oCdcONbcX7CmrsC07dDxyaGuso+GXqa6zjWVj/n/2rhH/PaByqJDz03N9Z6puJLcOmCBPe/InWs7fjoydzbxO/kYEn9SXL/uyOjsNbl/fD+gyMBupBfwgxfL3gdd7Sy/rn00cVSNfcjW7HsNKfuca3u9fgWJbL9xuXYveCE/HzEaAJ4wGvMfn6BlwA==");
		public static const en_ico:ByteArray = Base64.decode("Q1dTD6oGAAB4nEtgUG1g0FjAIMHI4CIowcDAUC/MxcrAYFOUkmYV5OKmUJGbk1dsBeTZKmWUlBRY6euXl5frlRvr5Rel6xtaWlrqGxjpGxnpAlXoFlfmlSRW6OYVKyvZKYBNcEktTi7KLCjJzM9TAPETk/JLS2yVlKDGVuQWwI3NK9ZLTMlPStVLzs/Vr0gs0DfUM9AHmQNUZOVclJpYkl8Ukp+fY+cIUqXglpNYnKEQUJSfllpcDDQ+MUfBOdhMQVchqTQzJ0XBxMLQRh9dJ5JZqS5AbGdkYGiqa2Cqa2QYYmhoZWhkZWisbWBsZWCApBeiEqLVN7UkMSWxJBFVs0kIUI+hBbJOFIVQvfkpmWmVhHUilCnY6KOFIXGhmpIMD9SC0qIccEylJOun5qTmpuaVFAMD1hAcsCnJVmn5RbmJJXaJBQU5mcmJIAP1K3SLM/KTs8sTy1J100CBbKOPUEiuk4A+8/XFH9W5ufow1cUlQalp+FUXh1QWpOoHpRbnlxYlpwKVK0OTiq8v0C1FmWWpKW5F+blgtxQkFhWngtTbKsE0gBSDbbHKzCsuScxLTvV0sQPq1svMTLEyMHd2MzOzNLF0MjB0NTU0dDRydrUwtHA1MbI0snABRRSGVphpKfnJpaBAhpqWAjTN3MzI3NHIxc3C1c3N1QRomoGjo4uRpbGbhYu5qbOxM8w0JK0w0/KLMtMzgSnbhXxTsRihAE5oqOGECDtMq8wcLY2NLF1dHc1xBQeGVphpnpiBS6xpnsiBCxHypyQ4cBqBNUnrQ4s/OwUGZyZgobhflBtIMjKk5qXnZBZnAAUYIhlBAqFCuz8pNzAyzJ07n0FAlGOS7dW01uqtvqyOzjp9Tbt0MsIXO2gmvt+yRW0K9yWrWdncdsrL7n25oRO04Oaxjo4bW5aZTT957ulLUV1bzWWPv5zRmdy47FL69mmZ4TeOHJH3OpwZvef5tNpg35jXB2/bvJT7xP1SmOfVsvJsr3im9jWy089yfUs0EWX1tFde9cv5fQSvDvfc95eUZ2v+En1z4wSbzGe5YofMHTFfcmod5Dd1Lox7G+wYECC2etmVJ2e6HSYtMLrls5XtrBb7XL5LK26FvzLJCLsksimltcHTQDJaLZzRbMP1L8v9pldMTODzNrPifLP19bclIgeLrLRyfF9tvRF/MTipPfTeYb+u2TN4by07/EBzQ/6WVWrl2h4vMll9p9zl+parzPJ7zY9tFZ8smV5OTmJIThV22jvDl+VL4ITXkgzCh7arHW3Y02AQWLiynyWPaaViVKNLQ/C2jdcmsRSxzmBoY2NjBIYugwMw1AGI+kvx");
		public static const enter_ico:ByteArray = Base64.decode("Q1dTDzQGAAB4nKWUT2gUVxzHJyk19KIWUUO9DBsFRWffvNn/42ZxdmenrGGtxq2gS5pMZt6a0dl948xsdlcQ7aFS0F7U9mAIpm1AjCSFpPVPJDGgiNRLC6aXBlMPtgdJFEUUNODbza5ZjQnBHmaY3/D9ft7vfd+P10ZtOEZt7KHqayjx03qKoo6uWvkxRQVNNcU3ixKdT+sZiydVo6PDtg0egFwu58y5nNjcD2AgEAAsBziOIQrGKmRsOc9krAZHiC4RRGQppmbYGs7QxVpux1m70eEoY/Np4w02YzllFbcjp4LTIC8bADpZUOQQER8xkWxjM4GxHhKKKlrSZauD3mniFLIsgpd1OrLbSzN0e1bTVdrth0HwrrOKhUTyhDgWehjWw3AwASEPOR66NrMunmWrvLPKWWsc2bIq23KV2cuw7gRHPJB3w2rzW9qyHataqrAk85ySDoJ3klxatqryJloja+ql81IVgHSURhnbIvHCUryqwqewmZbtkGwYuqbIRSDIM1YHVg7m5E7EpIpRB8Gc8ENbIjuLxxc/8HQaVNSW3YxSi6utRMFAoBlZOGsqiMgbygMTj5NeTK0TqZKJ06VeDNm0UFHf6KgYiuLSKryWsWw5o6CYGCJup6apfIBzcT63xx8Ns0LUA2GAY11+IRz2R/xet0/0BsE8a4WmYiVbDLlMUwnN5+V8AidK/qgkRd0QCqwgiFzAJflFnyfiilRoVdYKDZvafo3Mt/jh1Pcg6NKgvZ3TXHbzl2IDYUGUwjAqLRTHPGuFFpsf7lJpsepwZ3998X/iWBDx3pEG5UswRFORWnI1Xl/9CXnXUMSCTFJSk6Wy5XwT/+JH8tHdfY5auTr2bHxi+MDwhHCgf+K6/tP0+uye6R1X8Mit5X1jibqWZH93rGvwyAlmX9fJmS+71rRdwL9cWvfb6AqH8sOZ4+trn1BTvzeNdf9zNpncO374D9fdbwbuHils+e+7X+9Mo85kdsPjybYLvXeyqx62Pt36sDdpP0sUbo4MTM5s/3uj0l/70VY0eapX/+vQUN1Xm3oeDe2+PXpZW7f2xsCU+fmhur7L5svBE1dOjyev8vdHn9d/dtHnPDzw9Z4/W42e4dO+B33X+kZir3z3fm759/vOqaZd31LHly2rIVujtpGtvgarYiBP");
		public static const num_ico:ByteArray = Base64.decode("Q1dTD6UGAAB4nEtgUG1g0FjAIMHI4CIowcDAUC8swMrAYFOUkmYV5OKmUJGbk1dsBeTZKmWUlBRY6euXl5frlRvr5Rel6xtaWlrqGxjpGxnpAlXoFlfmlSRW6OYVKyvZKYBNcEktTi7KLCjJzM9TAPETk/JLS2yVlKDGVuQWwI3NK9ZLTMlPStVLzs/Vr0gs0DfUM9AHmQNUZOVclJpYkl8Ukp+fY+cIUqXglpNYnKEQUJSfllpcDDQ+MUfBOdhMQVchqTQzJ0XBxMLQRh9dJ5JZqS5AbGdkYGiqa2Cqa2QYYmhoZWhkZWisbWBsZWCApBeiEqLVN7UkMSWxJBFVs0mIoYmVsZGVgQWyZhS1UO35KZlplURpRqhUsNFHC0niwjYlGR60BaVFOeD4SknWT81JzU3NKykGBq8hOHhTkq3S8otyE0vsEgsKcjKTE0EG6lfoFmfkJ2eXJ5al6qaBgtpGH6GQXCcBfebriz/Cc3P1YaqLS4JS0/CrLg6pLEjVD0otzi8tSk4FKleGJhhfX6BbijLLUlPcivJzwW4pSCwqTgWpt1WCaQApBttilZlXXJKYl5zq6WIH1K2XmZli5WJmYmTkamFsYGFg5GpqaGhhYuHobGZi6Gps4OpqYuxio4+hFWZaSn5yKSiQoaalAE0zNzMydzRycbNwdXNzNTE0dDRwdHQxsjR2s3AxN3U2doaZhqQVZlp+UWZ6JjB9u5BvKhYjFMAJDTWcEGGHaZWLOaHgwNAKM80TS+ASaZoncuBChPwpCQ6cRmBN0vrQQtBOgcGZCVg07hdlB5KMDHmluUAOQxAjiBOrHXOnIruBieH///8Mc+fOZ1AQDay7771mesvsXNun7LqhJ7vKLjKouTFoqU4NCuBJYTwTMb2x89SSmXm9009c0NimW5I7hXXjrFTJhWq2WW894hTiFUSia3aX32dUUQiboLnom1luqvNNPcvgJNn0RP7W9TfWPdy0dNkqQYeg1fO9ZksvEFZgEBL0mirAVsTwbu3JzSE71wXXFt9wD305u8t3yjnuuoCt3jdnJKeKM2epXuk4w/KJUc/iZJ8xo8qBpJY97v88t+1+lFB9qE4hrLt6zoz5r2fn2jwVTGmbKbDwzFPrsxKccQ0es4JfMGhMYe7wWOqlsPGktzTDvAC+7OXTNnUkqHYxXf2ZG/dVO6t+S5Ndl5BCM4PHBY7bmroNBh4s5rdVvwew7Xbc1nLvVAennJFqg/AJ1sjnapXXWKY2dj5Y1W1ipl2WvU3kW0hjrDb/ba5orWjR26YHGNrY2BiBwcrgAAxqAHyxOiU=");
		public static const abc_ico:ByteArray = Base64.decode("Q1dTD00GAAB4nKWUX2gcRRzH5yxNoU+1MTUVW5YLRave7c7uXrK7XI5cb3chKUeOJEJFpJ3bnWsWb3fWnb3cBQPJU4mopUrtn6S1QdGmRcGUNgo+BPSlQaF9URp8UVAqVlREEaqCc5e75tLEGurDLvtbvt/P/OY7P+YQ2DMBHp8B7RGgP9gOABhv3bYZgGRgF7QB3eQqbtGjGqu6o8Nh6Gs8Xy6X42UpToLDPFRVlRdEXhRjTBGjo16IKjGPdkRTXI2gY2oFjh86xOOqNcqTUtgdjdaxFde/g/VoHNkkj+MWcfkK8nkYF/gqh4m0TIBRSIIhQoqpdFXFmUVEh7lcQAqYUoZHRS4z2MnFuHzJKdqcrMAkf7eziYV19qREASZiQiImwiEINShqUHpSkDRBaPIuK5etWRwiG4VotVkegrImqRoUms2rtHU7sZ3C6IbMK0ouyd+V5Mayta070fqloFg7L9vicRG72AspixfW4rUtrUACF4Up5PtFx0JVIF+J0WFiPV9GIzhWqEad5FeE99sS21k2e+8Dd12+oabhAC7cW02HRn3MD2BKSoGFmbyjPjDZLOslcEawbQbErfXio4Diqr472jBUxbVVNMejIfIs3KunmDvuOLamd8qiaCiSoAiikYBQkZV0plOGhiQYhizpSX6NtUGziVWqhlyn2YzW1Sl2pUXdVAzTNGQI00I6rYuqZCp6VyIjZRq0JmuDRgLnsMPmW79/6joIrjZoq3NayW7tUrr6X3GssTZoveuEu0Fab3O4y7/6/08c/4pYd6T5+iWY4kDmAXY1LrRtYe8IQHmLFeB2rXjuSP/YJGEfZ8+eA9va+v74+1RED48Ozp6ceKN9k/aONPv0rotv05EO57Xsu8ZIJHGgxZSXlJlWCvrO5D8nk5cjYiXy0tj5V4868+8NHHz4N/ek+dnMnplNj6gfTU60pvddfmjq5sGP3fHfH/tx7gf1yz//evm29/rOU21XN099v3X32He5py4s9k2DEz27FxdF7zi+vu+X7KWvXzzx087+F565Imw39dxSq/LFt+qhR49t+aCwf+nY9dyUMX/tVv4WvoYyzy5c2vvN6auFnkFux89npvF4z8W5XeUnpssH5vcqx39985Ob2+fev/HWV1eSWy/kPhzf8enCK+dulMCRlpYI2zXoYSn8A5sTHTs=");
		public static const num1_ico:ByteArray = Base64.decode("Q1dTD9sFAAB4nKWUT2jTUBzHXwdueBAmOpi4Q2gVnJK+vKR/Q1ttmwZ2KI6tnpy6t+RlC6ZJSNK1vehO/hkIQxRRmXpQ2cWLJ/UiTEUQ9SAIongQxMtA0IPMk7527datc4x5eA9+4fv9vF++78cbBfunwIE7oNcHpJ29AICzu7q3AZBwVE0ckmSmUjRMV6RV0j/hebYIYblcDpaFoOWMQxSPxyHHQ55nqYJ1q6aHK6zpBvwppk6QiKs4uu3plsnUajxmlbyk39/AVor2MtZ0g1i1xkhQsYqwgm2IghyscahIzDoEe5ZTsCwjla6pGNnA7gQz6FgacV2KxwaTHY4wLDNW0g2VCcVQAq51trCIRFeK51CY5cIsjwoIiYgXkXCIE0SOa/EuKZeseeJhFXu4xRxhuVCB50U+KiKu1bxK27Bbqq5VN2VeUTIJuCbJzWWrKsvR2iXHqN+XqkBikCIxPZfGi+rxqoqoWU4Reyls24au4BoQVlh3wlJOl/EkYbVa1Am4ItxqS/TP8vmNL7xYhE216w0RbWO1W6jaBA4R1yo5CqHyQGNg8nnai6NPElV2rGK9Fxs7Lqnpk/6moSaunyLqputhUyEDUoq6g7quinFe4KOhcCyX4dK5MEJxnhNi6Uwmlo1FQlEpkoBt1iZNtZRSLeQGTaW0aISPpnlJjuVkORdCKM2l0xIfF+SYFA1nhWyT1mJt0ixHH9fpfEtbp66DYOqDtjqnlezaj+KETFqSMygn/yuONmuTNtAe7mZpA63hLn06+j9x/BOx7kjDxiOYYkC2gz6NT3u66O4D6BRPC3ChXhzrm1e0Rz4wO3sbdPf0P/5V+PAZXAdgZrowNyXMdJXM/I17b5ybC7ee5Re+90eGY+zvzHuo4UtXRrYff733iaR1VMG1PvXlnqnLoyhzMvBn36cTP7jkl8Pd/QflxZ8Pvt1NBQoX5xZ3v/uaYM+8KO+4yoYHp42Pr84/HHHuPxffzveCc52dPtoMOEJ7+guJl+Wi");
		public static const num2_ico:ByteArray = Base64.decode("Q1dTDw0GAAB4nKWUTWjUQBiGp0JbvLVVoaKHsFWxSnYyk/0N29XdzQYqLEqbk7+dJpM2uJuEJNvdHsR6EVQEEUVU/DlU0EMFFcEWRFRElHoUCurBiwcVQQ9STzq73W231krRQwLf8L7PfPPOxwyAzWNg63XQ2QTk9k4AwNE1bc0AJFzdkPpkhSsX8pYnsaonMOz7jgRhqVQKlsSg7Q5BFI/HoYAhxjxT8N6o5ZMyb3ldgSRXJcjU01zT8U3b4io1GbSLfk8gUMOWC8481vKCRLcHaVCzC7BMHIiCAqxwmEjKuJT4tqvadj6Zqqg4JU+8YW6PaxvU8xie5LlMf4TjucGimde5UAwl4O/OBhaV2ZfEAgrzQpjHSEVIQlhC4nZBlAShwTunnLPmqE904pMGc4QXQirGkoglYZF5kbZmt3XTGF2ReUHJJeBvSa4sW12bj9YpuvnqfekapHlaoJbvsXhRNV5dkwzbLRA/SRwnb2qkAoRl3hu2tcMlMkJ5oxJ1Ai4I/7UldrJc7u8XXijAutrz+6jxd7WnjjoU9lHPLroaZfKu2sDkcqwX1xyhuuLahWovDnE9WtH3BOqGiri6i2Rank8sjfbKSeYOmqYuxbGIo6FwLJsWUtkwQnEsiLFUOh3LxCKhqBxJwCXWOk23tWIl5BpNZ7RoBEdTWFZiWUXJhhBKCamUjOOiEpOj4YyYqdMarHWa7ZpDJptv+d+pf0Bw1UFbnNNCdku3EsLplKykUVZZLo4l1jqtd2m4K6X1NoY7t7T7f+JYFvHHkYa1RzDJgcwq9jQ+WtfK/k0AH8KsAFPVQn37RDMeNIErV66BtnXdk9/VmXfgIgBnTqo3x8QzrUUrd+nGK/fyp6tPc5++dEf6Y/yP9GtokNPn9q/eN71hSjZWjYILG/Xn68fODqD0wa6fm94c+Cr0vN/R1r1Nmf028WE82aWeuDm79vG4yIGO9l3n21pc8GXixT118nb/EW/GfHjk2ZaXQ82Ptu698Xka3T117H7Hx+Wxa2/dYa0fb2lpYu2DnewUvwC5Evsu");
		public static const location_ico:ByteArray = Base64.decode("Q1dTEdsFAAB4nKWUT2sTQRjGJ2oL6sGWUuhFWFPqQdnMZrdNmiWJaf5BKaElphV60enupF3c3VlmNk16snjwoOjNIiIogoJYxUIVtGi/gIet0IMgot70Mwh1d5ukaY1a9bAsMzzP75155uWdAKvg2D3QFwDZ7j4AwKWerg4A4lQty8VsnqsZuslkd5UIztm2JUNYrVZDVSlE6CwMx2IxKIhQFHlXwbMF00Y13mT9wSTnE7KYKVSzbI2YnLdGM6RiJ4LBOrZmWE2syUJIJTM4pBAD1pAFwyEBehxXJGcoRjahJUL05Iin4vI6YnPcBCVlzJiLRzqXORvheG6moukqNyRF43Cvs4WFs+6XFIVwhBeGeHG4JAqyMCgL0dOCJAtCi3dbuW0tYBupyEbtzNE95l3aup2oWnlhX+YdJReHe5Lcd7aFwu/TNQzYUDO7iMu/V7PSgoVhETNSoQp25f311ykU5FGT2chU8Gg26W6ENE2Vc3lJSkvRdD4iDuYi4XBayEh5IRKVIqKUjg2P+BfdbW3QskSpGNi06zT1L2gt1gZtnGqzmtsf7ajp/VHbIJpnxVSbx2qeEsN/BQtRhr2kEsFGVF5Mfr6y1iam3J+O8JO1QVPbXGifNLX1Ittb5H9i+iWCaz7MTk7/3NKq0uxQq0J1fwSpCsQ69qoxt0vD/sRQFblMqIHsJLIsXVOQB4Q1ns0R5WIVzWO+7E2PONwRtj0SrA/BJAcyB7a2ttZ7T7gDMgCcO84b5/XGZeeZ88L9X3Necs4rd7G6sciFAVgHxJdN+JM1AAYKS6Crd6x78+6XyRV+dm06fvtw7XOAXjjao7+/TouLJ8fAYPSW8zZw5vzD/ke50NdUfPnp9Lf7YEk4svngcenQaCp3bmpy6ji4+anj1EBp+eDKu/HS2uaHxPfeGx+vPnkeT4ErnZ0BtyZIuaV/ACwq6Rg=");
		
		public static const defaultWidth:Number = 60;
		public static const defaultHeight:Number = 65;
		
		public static const ru_charset:Vector.<Vector.<Object>> = new <Vector.<Object>>
		[
		new <Object>[0,1,2,3,4,5,6,7,backspace_ico,'TAB',10,11,12,enter_ico,14,15,shift_ico_up,ctrl_en_ico,'ALT',19,'CAPSLOCK',num_ico,22,23,24,25,26,esc_ico,28,29,30,31,ru_ico,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,'0','1','2','3','4','5','6','7','8','9',58,59,60,61,62,63,64,'ф','и','с','в','у','а','п','р','ш','о','л','д','ь','т','щ','з','й','к','ы','е','г','м','ц','ч','н','я',',','.',93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,'ж',187,'б',189,'ю','.',192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,'х',220,'ъ',"э",223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250],
		new <Object>[0,1,2,3,4,5,6,7,backspace_ico,'TAB',10,11,12,enter_ico,14,15,shift_ico_down,ctrl_en_ico,'ALT',19,'CAPSLOCK',num_ico,22,23,24,25,26,esc_ico,28,29,30,31,ru_ico,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,'0','1','2','3','4','5','6','7','8','9',58,59,60,61,62,63,64,'Ф','И','С','В','У','А','П','Р','Ш','О','Л','Д','Ь','Т','Щ','З','Й','К','Ы','Е','Г','М','Ц','Ч','Н','Я',',','.',93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,'Ж',187,'Б',189,'Ю',',',192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,'Х',220,'Ъ','Э',223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250]
		];
									
		public static const en_charset:Vector.<Vector.<Object>> = new <Vector.<Object>>
		[
		new <Object>[0,1,2,3,4,5,6,7,backspace_ico,'TAB',10,11,12,enter_ico,14,15,shift_ico_up,ctrl_ru_ico,'ALT',19,'CAPSLOCK',num_ico,22,23,24,25,26,esc_ico,28,29,30,31,en_ico,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,'0','1','2','3','4','5','6','7','8','9',58,59,60,61,62,63,64,'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','#','@','_',94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,';',187,',',189,'.','/',192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,'[',220,']',"'",223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250],
		new <Object>[0,1,2,3,4,5,6,7,backspace_ico,'TAB',10,11,12,enter_ico,14,15,shift_ico_down,ctrl_ru_ico,'ALT',19,'CAPSLOCK',num_ico,22,23,24,25,26,esc_ico,28,29,30,31,en_ico,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,'0','1','2','3','4','5','6','7','8','9',58,59,60,61,62,63,64,'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','#','@','_',94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,':',187,'<',189,'>','?',192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,'{',220,'}','"',223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250]
		];
		
		public static const num_charset:Vector.<Vector.<Object>> = new <Vector.<Object>>
		[
		new <Object>[0,1,2,3,4,5,6,7,backspace_ico,'TAB',10,11,12,enter_ico,14,15,num1_ico,ctrl_ru_ico,'ALT',19,'CAPSLOCK',abc_ico,22,23,24,25,26,esc_ico,28,29,30,31,en_ico,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,'0','1','2','3','4','5','6','7','8','9',58,59,60,61,62,63,64,'#',';','=','%','3','&','*','-','8','+','(',')','.',',','9','0','1','4','$','5','7',':','2','>','6','<','№','@','_','/',95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,';',187,'?',189,'!','/',192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,'[',220,']',"'",223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250],
		new <Object>[0,1,2,3,4,5,6,7,backspace_ico,'TAB',10,11,12,enter_ico,14,15,num2_ico,ctrl_ru_ico,'ALT',19,'CAPSLOCK',num_ico,22,23,24,25,26,esc_ico,28,29,30,31,en_ico,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,'0','1','2','3','4','5','6','7','8','9',58,59,60,61,62,63,64,'\\','♪','♣','|','¥','[',']','<','®','>','{','}','☺','♫','™','¢','€','£','/','₽','©','♦','$','♠','œ','♥','#','@','_',94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,':',187,'☻',189,'☼','?',192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,'{',220,'}','"',223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250]
		];
		
		public function Key(attrs:Object = null)
		{
			super();
			
			attributes.merge(attrs);
		}
		
		public function setKeyCode(keyCode:int):void
		{
			attributes["keyCode"] = keyCode;
		}
		
		public function getKeyCode():int
		{
			return attributes["keyCode"];
		}
	}
}
