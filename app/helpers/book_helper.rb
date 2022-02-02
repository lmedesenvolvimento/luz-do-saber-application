module BookHelper
	def verify_url(url)
		#para prevenir problema com books antigos cadastrados com endereco errado
		correta = ['https:/', ENV['MINIO_HOSTNAME'], ENV['MINIO_BUCKET_NAME']].join('/')
		if url.present?
			if !url.start_with?( correta )
				#ate onde substitui
				position = url.index('/books')
	    		url = [ correta, url[position,url.length] ].join()
	    	end
	    end
    	url
	end
end