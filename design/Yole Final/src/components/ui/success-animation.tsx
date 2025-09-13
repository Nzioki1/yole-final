import { motion } from 'motion/react'
import { Check } from 'lucide-react'

export function SuccessAnimation() {
  return (
    <div className="relative w-24 h-24 mx-auto">
      {/* Outer ring animation */}
      <motion.div
        className="absolute inset-0 border-4 border-green-200 rounded-full"
        initial={{ scale: 0, opacity: 0 }}
        animate={{ 
          scale: [0, 1.2, 1],
          opacity: [0, 1, 0.3]
        }}
        transition={{
          duration: 0.8,
          ease: "easeOut",
          times: [0, 0.6, 1]
        }}
      />
      
      {/* Inner success circle */}
      <motion.div
        className="absolute inset-2 bg-gradient-to-br from-green-400 to-green-600 rounded-full flex items-center justify-center shadow-lg"
        initial={{ scale: 0 }}
        animate={{ scale: 1 }}
        transition={{
          delay: 0.2,
          duration: 0.5,
          ease: "backOut"
        }}
      >
        <motion.div
          initial={{ scale: 0, rotate: -180 }}
          animate={{ scale: 1, rotate: 0 }}
          transition={{
            delay: 0.5,
            duration: 0.4,
            ease: "backOut"
          }}
        >
          <Check className="h-8 w-8 text-white" />
        </motion.div>
      </motion.div>
      
      {/* Floating particles */}
      {[...Array(6)].map((_, i) => (
        <motion.div
          key={i}
          className="absolute w-2 h-2 bg-green-400 rounded-full"
          style={{
            top: '50%',
            left: '50%',
            transform: 'translate(-50%, -50%)',
          }}
          initial={{ scale: 0, opacity: 1 }}
          animate={{
            scale: [0, 1, 0],
            opacity: [1, 1, 0],
            x: [0, (Math.cos(i * 60 * Math.PI / 180) * 40)],
            y: [0, (Math.sin(i * 60 * Math.PI / 180) * 40)],
          }}
          transition={{
            delay: 0.8 + i * 0.1,
            duration: 1.2,
            ease: "easeOut"
          }}
        />
      ))}
    </div>
  )
}