require 'uri'

module ParkingsDonostiService
	def self.get_parkings_info
	  	url = 'https://www.donostia.eus/info/ciudadano/camaras_trafico.nsf/dameParkings?OpenAgent&idioma=cas'
		uri = URI(url)
		response = Net::HTTP.get(uri)
		data = JSON.parse(response)
		info = {}

		require 'iconv' unless String.method_defined?(:encode)

		data.each do |parking|
			puts parking.inspect
			unless parking["Nombre"].nil? or parking["Datos"].nil? or parking["Datos"].empty? \
			 or parking["Datos"].include? "Sin informac" or parking["Datos"].include? "no disponible"
				if String.method_defined?(:encode)
					str = parking["Datos"].encode('UTF-16', 'UTF-8', :invalid => :replace, :replace => '') 
					str.encode!('UTF-8', 'UTF-16')
				else
				  #ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
				  #str = ic.iconv(parking["Datos"])
				end
				datos = str.match(/Plazas en rota.* ([0-9]+) \(([0-9]+)%\)/)
				libres = 0
				porcentaje = 0
				unless datos.nil?
					libres = datos[1]
					porcentaje = datos[2]
				else
					puts "Error matching: #{str}"
				end
				info[parking["Nombre"]] = {libres: libres, porcentaje: porcentaje}
			end
		end
		info
	end
end